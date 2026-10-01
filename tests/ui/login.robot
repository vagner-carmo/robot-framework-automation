*** Settings ***
Resource    ../../resources/keywords/api_keywords.robot
Resource    ../../resources/keywords/ui_keywords.robot

*** Test Cases ***
User Should Be Able To Login Successfully
    [Documentation]    Verifies that a user can log in successfully through the web interface.
    [Tags]    ui    login    smoke    regression

    ${user}=    Create Random User

    ${response}=    Create User
    ...    ${user}[name]
    ...    ${user}[email]
    ...    ${user}[password]
    ...    ${user}[administrator]

    Status Should Be    201    ${response}

    Open Login Page
    Login Through UI
    ...    ${user}[email]
    ...    ${user}[password]

    Verify Successful Login    ${user}[name]

User Should Not Be Able To Login With Invalid Credentials
    [Documentation]    Verifies that a user cannot log in with invalid credentials.
    [Tags]    ui    login    regression

    ${email}=    FakerLibrary.Email
    ${password}=    FakerLibrary.Password

    Open Login Page
    Login Through UI
    ...    ${email}
    ...    ${password}

    Verify Invalid Login    Email e/ou senha inválidos

User Should Not Be Able To Login With Empty Credentials
    [Documentation]    Verifies that validation messages are displayed when email and password are empty.
    [Tags]    ui    login    regression

    Open Login Page

    Login Through UI
    ...    ${EMPTY}
    ...    ${EMPTY}

    Verify Empty Login Fields