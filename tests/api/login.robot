*** Settings ***
Library    Collections
Resource   ../../resources/keywords/api_keywords.robot

*** Test Cases ***
User Should Be Able To Login Successfully
    [Documentation]    Verifies that a user can log in successfully with valid credentials.
    [Tags]    api    login    smoke    regression
    ${user}    ${user_id}=    Create Random User And Return Id

    ${login_response}=    Login With Credentials
    ...    ${user}[email]
    ...    ${user}[password]

    Status Should Be    200    ${login_response}

    ${response_body}=    Validate Response Is JSON    ${login_response}
    Validate Response Is Object    ${response_body}
    Validate Response Contains Message    ${response_body}

    Validate Response Against Schema
    ...    ${response_body}
    ...    ${LOGIN_SUCCESS_SCHEMA}

    Dictionary Should Contain Key    ${response_body}    authorization

    ${token}=    Get From Dictionary    ${response_body}    authorization
    Should Not Be Empty    ${token}


User Should Not Be Able To Login With Invalid Credentials
    [Documentation]    Verifies that a user cannot log in with invalid credentials.
    [Tags]    api    login    regression
    ${user}=    Create Random User

    ${response}=    Login With Credentials
    ...    ${user}[email]
    ...    ${user}[password]
    ...    401

    Status Should Be    401    ${response}

    ${response_body}=    Validate Response Is JSON    ${response}
    Validate Response Is Object    ${response_body}
    Validate Response Contains Message    ${response_body}

    Validate Response Against Schema
    ...    ${response_body}
    ...    ${LOGIN_INVALID_SCHEMA}

User Should Not Be Able To Login With Empty Fields
    [Documentation]    Verifies that login fails when required fields are empty.
    [Tags]    api    login    regression
    ${response}=    Login With Credentials
    ...    ${EMPTY}
    ...    ${EMPTY}
    ...    400

    Status Should Be    400    ${response}

    ${response_body}=    Validate Response Is JSON    ${response}
    Validate Response Is Object    ${response_body}

    Validate Response Against Schema
    ...    ${response_body}
    ...    ${LOGIN_EMPTY_FIELDS_SCHEMA}

    Dictionary Should Contain Key    ${response_body}    email
    Dictionary Should Contain Key    ${response_body}    password

    ${email_message}=    Get From Dictionary    ${response_body}    email
    ${password_message}=    Get From Dictionary    ${response_body}    password

    Should Be Equal    ${email_message}    email não pode ficar em branco
    Should Be Equal    ${password_message}    password não pode ficar em branco