*** Settings ***
Library    SeleniumLibrary    timeout=10s
Resource    ../variables/ui_variables.robot
Resource    ../locators/login_locators.robot
Resource    ../locators/register_locators.robot

*** Keywords ***
Open Browser Session
    [Documentation]    Opens a browser session for the test suite.
    Open Browser    ${UI_BASE_URL}/login    Chrome
    Maximize Browser Window


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