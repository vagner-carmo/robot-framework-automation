*** Settings ***
Library    SeleniumLibrary    timeout=10s
Library    OperatingSystem
Resource    ../variables/ui_variables.robot
Resource    ../locators/login_locators.robot
Resource    ../locators/register_locators.robot
Resource    ../locators/product_locators.robot

*** Keywords ***
Open Browser Session
    [Documentation]    Opens a browser session for the test suite.
    IF    $HEADLESS
        ${options}=    Evaluate    sys.modules['selenium'].webdriver.ChromeOptions()    sys
        Evaluate    $options.add_argument("--headless=new")
        Evaluate    $options.add_argument("--window-size=1920,1080")
        Open Browser    ${UI_BASE_URL}/login    Chrome    options=${options}
    ELSE
        Open Browser    ${UI_BASE_URL}/login    Chrome
        Maximize Browser Window
    END


Open Login Page
    [Documentation]    Navigates to the ServeRest login page.
    Go To    ${UI_BASE_URL}/login


Login Through UI
    [Documentation]    Fills in the login form and submits the provided credentials.
    [Arguments]    ${email}    ${password}

    Input Text    ${LOGIN_EMAIL_INPUT}    ${email}
    Input Text    ${LOGIN_PASSWORD_INPUT}    ${password}
    Click Element    ${LOGIN_BUTTON}


Verify Successful Login
    [Documentation]    Verifies that the user is redirected to the home page and displays the welcome message.
    [Arguments]    ${user_name}

    Wait Until Location Contains    /home

    Wait Until Element Is Visible    ${WELCOME_MESSAGE}

    ${welcome_text}=    Get Text    ${WELCOME_MESSAGE}
    Should Be Equal    ${welcome_text}    Bem Vindo ${user_name}


Verify Invalid Login
    [Documentation]    Verifies that an error message is displayed after an unsuccessful login attempt.
    [Arguments]    ${expected_message}

    Wait Until Element Is Visible    ${ALERT_MESSAGE_TEXT}

    ${alert_text}=    Get Text    ${ALERT_MESSAGE_TEXT}
    Should Be Equal    ${alert_text}    ${expected_message}

    Location Should Be    ${UI_BASE_URL}/login


Verify Empty Login Fields
    [Documentation]    Verifies that required field validation messages are displayed when email and password are empty.

    Wait Until Element Is Visible    ${EMAIL_REQUIRED_MESSAGE}
    Wait Until Element Is Visible    ${PASSWORD_REQUIRED_MESSAGE}

    Element Text Should Be    ${EMAIL_REQUIRED_MESSAGE}       Email é obrigatório
    Element Text Should Be    ${PASSWORD_REQUIRED_MESSAGE}    Password é obrigatório

    Location Should Be    ${UI_BASE_URL}/login


Open Registration Page
    [Documentation]    Opens the user registration page from the login page.
    Click Element    ${REGISTER_BUTTON}


Fill Registration Form
    [Documentation]    Fills the registration form with the provided user information.
    [Arguments]    ${name}    ${email}    ${password}    ${administrator}

    Input Text    ${REGISTER_NAME_INPUT}        ${name}
    Input Text    ${REGISTER_EMAIL_INPUT}       ${email}
    Input Text    ${REGISTER_PASSWORD_INPUT}    ${password}

    IF    $administrator
        Select Checkbox    ${REGISTER_ADMIN_CHECKBOX}
    END


Submit Registration Form
    [Documentation]    Submits the user registration form.
    Click Element    ${REGISTER_BUTTON}


Verify Successful Registration
    [Documentation]    Verifies that the registration success message is displayed.
    Wait Until Element Is Visible    ${REGISTRATION_SUCCESS_MESSAGE}
    Element Text Should Be    ${REGISTRATION_SUCCESS_MESSAGE}    Cadastro realizado com sucesso


Verify Email Already Exists
    [Documentation]    Verifies that an error message is displayed when the registered email is already in use.
    Wait Until Element Is Visible    ${REGISTER_EMAIL_EXISTS_MESSAGE}
    Element Text Should Be    ${REGISTER_EMAIL_EXISTS_MESSAGE}    Este email já está sendo usado


Verify Empty Registration Fields
    [Documentation]    Verifies that required field validation messages are displayed when registration fields are empty.

    Wait Until Element Is Visible    ${REGISTER_NAME_REQUIRED_MESSAGE}
    Wait Until Element Is Visible    ${REGISTER_EMAIL_REQUIRED_MESSAGE}
    Wait Until Element Is Visible    ${REGISTER_PASSWORD_REQUIRED_MESSAGE}

    Element Text Should Be    ${REGISTER_NAME_REQUIRED_MESSAGE}        Nome é obrigatório
    Element Text Should Be    ${REGISTER_EMAIL_REQUIRED_MESSAGE}       Email é obrigatório
    Element Text Should Be    ${REGISTER_PASSWORD_REQUIRED_MESSAGE}    Password é obrigatório


Open Product Registration Page
    [Documentation]    Opens the product registration page from the main navigation.
    Click Element    ${PRODUCT_REGISTER_NAV}


Fill Product Registration Form
    [Documentation]    Fills the product registration form with the provided information and image.
    [Arguments]    ${name}    ${price}    ${description}    ${quantity}    ${image_path}

    Input Text    ${PRODUCT_NAME_INPUT}           ${name}
    Input Text    ${PRODUCT_PRICE_INPUT}          ${price}
    Input Text    ${PRODUCT_DESCRIPTION_INPUT}    ${description}
    Input Text    ${PRODUCT_QUANTITY_INPUT}       ${quantity}
    Choose File   ${PRODUCT_IMAGE_INPUT}          ${image_path}


Submit Product Registration
    [Documentation]    Submits the product registration form.
    Click Element    ${PRODUCT_REGISTER_BUTTON}


Verify Product Is Listed
    [Documentation]    Verifies that the registered product is displayed in the product list.
    [Arguments]    ${product_name}

    ${product_locator}=    Set Variable    xpath=//table//td[normalize-space()='${product_name}']

    Wait Until Element Is Visible    ${product_locator}
    Element Text Should Be           ${product_locator}    ${product_name}


Verify Empty Product Fields
    [Documentation]    Verifies that required field validation messages are displayed when product fields are empty.

    Wait Until Element Is Visible    ${PRODUCT_NAME_REQUIRED_MESSAGE}
    Wait Until Element Is Visible    ${PRODUCT_PRICE_REQUIRED_MESSAGE}
    Wait Until Element Is Visible    ${PRODUCT_DESCRIPTION_REQUIRED_MESSAGE}
    Wait Until Element Is Visible    ${PRODUCT_QUANTITY_REQUIRED_MESSAGE}

    Element Text Should Be    ${PRODUCT_NAME_REQUIRED_MESSAGE}           Nome é obrigatório
    Element Text Should Be    ${PRODUCT_PRICE_REQUIRED_MESSAGE}          Preco é obrigatório
    Element Text Should Be    ${PRODUCT_DESCRIPTION_REQUIRED_MESSAGE}   Descricao é obrigatório
    Element Text Should Be    ${PRODUCT_QUANTITY_REQUIRED_MESSAGE}       Quantidade é obrigatório

    Location Should Be    ${UI_BASE_URL}/admin/cadastrarprodutos


Verify Product Name Already Exists
    [Documentation]    Verifies that an error message is displayed when a product with the same name already exists.

    Wait Until Element Is Visible    ${PRODUCT_NAME_EXISTS_MESSAGE}

    Element Text Should Be
    ...    ${PRODUCT_NAME_EXISTS_MESSAGE}
    ...    Já existe produto com esse nome

    Location Should Be    ${UI_BASE_URL}/admin/cadastrarprodutos


Open Product Test Session
    [Documentation]    Opens the browser, creates an administrator, authenticates the user, and stores the API token for the product test suite.

    IF    $HEADLESS
        ${options}=    Evaluate    sys.modules['selenium'].webdriver.ChromeOptions()    sys
        Evaluate    $options.add_argument("--headless=new")
        Evaluate    $options.add_argument("--window-size=1920,1080")
        Open Browser    ${UI_BASE_URL}/login    Chrome    options=${options}
    ELSE
        Open Browser    ${UI_BASE_URL}/login    Chrome
        Maximize Browser Window
    END

    ${admin}=    Create Random User

    ${response}=    Create User
    ...    ${admin}[name]
    ...    ${admin}[email]
    ...    ${admin}[password]
    ...    ${admin}[administrator]

    Status Should Be    201    ${response}

    ${login_response}=    Login With Credentials
    ...    ${admin}[email]
    ...    ${admin}[password]

    Status Should Be    200    ${login_response}

    ${token}=    Set Variable    ${login_response.json()}[authorization]

    Login Through UI
    ...    ${admin}[email]
    ...    ${admin}[password]

    Verify Successful Login    ${admin}[name]

    Set Suite Variable    ${ADMIN_USER}    ${admin}
    Set Suite Variable    ${API_TOKEN}    ${token}