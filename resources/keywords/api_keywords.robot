*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    FakerLibrary
Library    JSONLibrary
Resource   ../variables/api_variables.robot

*** Keywords ***
Validate Response Is JSON
    [Documentation]    Validates that the API response has a JSON content type and contains valid JSON data.
    [Arguments]    ${response}

    ${content_type}=    Get From Dictionary    ${response.headers}    Content-Type
    Should Contain    ${content_type}    application/json

    ${response_body}=    Set Variable    ${response.json()}

    RETURN    ${response_body}


Validate Response Is Object
    [Documentation]    Validates that the response body is a JSON object.
    [Arguments]    ${response_body}

    ${is_object}=    Evaluate    isinstance($response_body, dict)
    Should Be True    ${is_object}


Validate Response Contains Message
    [Documentation]    Validates that the response contains a non-empty message field.
    [Arguments]    ${response_body}

    Dictionary Should Contain Key    ${response_body}    message

    ${message}=    Get From Dictionary    ${response_body}    message
    Should Not Be Empty    ${message}

    RETURN    ${message}


Login With Credentials
    [Documentation]    Authenticates a user using email and password and returns the API response.
    [Arguments]    ${email}    ${password}    ${expected_status}=200

    Create Session    api    ${API_BASE_URL}

    ${body}=    Create Dictionary
    ...    email=${email}
    ...    password=${password}

    ${response}=    POST On Session
    ...    api
    ...    /login
    ...    json=${body}
    ...    expected_status=${expected_status}

    RETURN    ${response}


Create User
    [Documentation]    Creates a user with the provided information and returns the API response.
    [Arguments]    ${name}    ${email}    ${password}    ${administrator}    ${expected_status}=201

    Create Session    api    ${API_BASE_URL}

    ${body}=    Create Dictionary
    ...    nome=${name}
    ...    email=${email}
    ...    password=${password}
    ...    administrador=${administrator}

    ${response}=    POST On Session
    ...    api
    ...    /usuarios
    ...    json=${body}
    ...    expected_status=${expected_status}

    RETURN    ${response}


Create Random User
    [Documentation]    Generates random user data using Faker and returns the user information as a dictionary.
    [Arguments]    ${administrator}=true

    ${name}=    FakerLibrary.Name
    ${email}=    FakerLibrary.Email
    ${password}=    FakerLibrary.Password

    ${user}=    Create Dictionary
    ...    name=${name}
    ...    email=${email}
    ...    password=${password}
    ...    administrator=${administrator}

    RETURN    ${user}


Create Random User And Return Id
    [Documentation]    Creates a random user and returns both the generated user data and its ID.
    
    ${user}=    Create Random User

    ${response}=    Create User
    ...    ${user}[name]
    ...    ${user}[email]
    ...    ${user}[password]
    ...    ${user}[administrator]

    Status Should Be    201    ${response}

    ${response_body}=    Set Variable    ${response.json()}
    ${user_id}=    Get From Dictionary    ${response_body}    _id

    RETURN    ${user}    ${user_id}


Get All Users
    [Documentation]    Retrieves all registered users and returns the API response.
    [Arguments]    ${expected_status}=200

    Create Session    api    ${API_BASE_URL}

    ${response}=    GET On Session
    ...    api
    ...    /usuarios
    ...    expected_status=${expected_status}

    RETURN    ${response}


Get User
    [Documentation]    Retrieves a user by ID and returns the API response.
    [Arguments]    ${user_id}    ${expected_status}=200

    Create Session    api    ${API_BASE_URL}

    ${response}=    GET On Session
    ...    api
    ...    /usuarios/${user_id}
    ...    expected_status=${expected_status}

    RETURN    ${response}


Update User
    [Documentation]    Updates an existing user by ID and returns the API response.
    [Arguments]    ${user_id}    ${name}    ${email}    ${password}    ${administrator}    ${expected_status}=200

    Create Session    api    ${API_BASE_URL}

    ${body}=    Create Dictionary
    ...    nome=${name}
    ...    email=${email}
    ...    password=${password}
    ...    administrador=${administrator}

    ${response}=    PUT On Session
    ...    api
    ...    /usuarios/${user_id}
    ...    json=${body}
    ...    expected_status=${expected_status}

    RETURN    ${response}


Delete User
    [Documentation]    Deletes a user by ID and returns the API response.
    [Arguments]    ${user_id}    ${expected_status}=200

    Create Session    api    ${API_BASE_URL}

    ${response}=    DELETE On Session
    ...    api
    ...    /usuarios/${user_id}
    ...    expected_status=${expected_status}

    RETURN    ${response}


Validate Response Against Schema
    [Documentation]    Validates a JSON response body against a JSON schema file.
    [Arguments]    ${response_body}    ${schema_path}

    Validate Json By Schema File    ${response_body}    ${schema_path}