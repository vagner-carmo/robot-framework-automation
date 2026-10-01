*** Settings ***
Library    SeleniumLibrary    timeout=10s
Resource    ../variables/ui_variables.robot
Resource    ../locators/login_locators.robot

*** Keywords ***
Open Login Page
    [Documentation]    Opens the ServeRest login page in the browser.
    Open Browser    ${UI_BASE_URL}/login    Chrome
    Maximize Browser Window


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