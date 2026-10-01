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


Create Random Admin User And Login
    [Documentation]    Creates a random administrator user, logs in with the created credentials, and returns the authorization token.

    ${user}=    Create Random User

    ${create_response}=    Create User
    ...    ${user}[name]
    ...    ${user}[email]
    ...    ${user}[password]
    ...    ${user}[administrator]

    Status Should Be    201    ${create_response}

    ${create_body}=    Validate Response Is JSON    ${create_response}
    Validate Response Is Object    ${create_body}

    ${login_response}=    Login With Credentials
    ...    ${user}[email]
    ...    ${user}[password]

    Status Should Be    200    ${login_response}

    ${login_body}=    Validate Response Is JSON    ${login_response}
    Validate Response Is Object    ${login_body}

    Dictionary Should Contain Key    ${login_body}    authorization

    ${token}=    Get From Dictionary    ${login_body}    authorization
    Should Not Be Empty    ${token}

    RETURN    ${token}
    

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


Create Product
    [Documentation]    Creates a product using the provided data and authorization token.
    [Arguments]    ${name}    ${price}    ${description}    ${quantity}    ${token}    ${expected_status}=201

    ${headers}=    Create Dictionary
    ...    Authorization=${token}
    ...    Content-Type=application/json

    ${body}=    Create Dictionary
    ...    nome=${name}
    ...    preco=${price}
    ...    descricao=${description}
    ...    quantidade=${quantity}

    Create Session    api    ${API_BASE_URL}

    ${response}=    POST On Session
    ...    api
    ...    /produtos
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=${expected_status}

    RETURN    ${response}


Create Random Product
    [Documentation]    Creates a product with randomly generated data and returns the product data and API response.
    [Arguments]    ${token}    ${expected_status}=201

    ${product_name}=    FakerLibrary.Name
    ${description}=    FakerLibrary.Sentence
    ${price}=    FakerLibrary.Random Int    min=1    max=1000
    ${quantity}=    FakerLibrary.Random Int    min=1    max=100

    ${response}=    Create Product
    ...    ${product_name}
    ...    ${price}
    ...    ${description}
    ...    ${quantity}
    ...    ${token}
    ...    ${expected_status}

    ${product}=    Create Dictionary
    ...    name=${product_name}
    ...    description=${description}
    ...    price=${price}
    ...    quantity=${quantity}

    RETURN    ${product}    ${response}


Get All Products
    [Documentation]    Retrieves all products and returns the API response.
    [Arguments]    ${expected_status}=200

    Create Session    api    ${API_BASE_URL}

    ${response}=    GET On Session
    ...    api
    ...    /produtos
    ...    expected_status=${expected_status}

    RETURN    ${response}


Get Product
    [Documentation]    Retrieves a product by its ID and returns the API response.
    [Arguments]    ${product_id}    ${expected_status}=200

    Create Session    api    ${API_BASE_URL}

    ${response}=    GET On Session
    ...    api
    ...    /produtos/${product_id}
    ...    expected_status=${expected_status}

    RETURN    ${response}

Delete Product
    [Documentation]    Deletes a product by its ID using the provided authorization token.
    [Arguments]    ${product_id}    ${token}    ${expected_status}=200

    ${headers}=    Create Dictionary
    ...    Authorization=${token}
    ...    Content-Type=application/json

    Create Session    api    ${API_BASE_URL}

    ${response}=    DELETE On Session
    ...    api
    ...    /produtos/${product_id}
    ...    headers=${headers}
    ...    expected_status=${expected_status}

    RETURN    ${response}

Create Cart
    [Documentation]    Creates a shopping cart with the provided product and quantity using the authorization token.
    [Arguments]    ${product_id}    ${quantity}    ${token}    ${expected_status}=201

    ${headers}=    Create Dictionary
    ...    Authorization=${token}
    ...    Content-Type=application/json

    ${product}=    Create Dictionary
    ...    idProduto=${product_id}
    ...    quantidade=${quantity}

    ${products}=    Create List    ${product}

    ${body}=    Create Dictionary
    ...    produtos=${products}

    Create Session    api    ${API_BASE_URL}

    ${response}=    POST On Session
    ...    api
    ...    /carrinhos
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=${expected_status}

    RETURN    ${response}

Update Product
    [Documentation]    Updates a product by its ID using the provided data and authorization token.
    [Arguments]    ${product_id}    ${name}    ${price}    ${description}    ${quantity}    ${token}    ${expected_status}=200

    ${headers}=    Create Dictionary
    ...    Authorization=${token}
    ...    Content-Type=application/json

    ${body}=    Create Dictionary
    ...    nome=${name}
    ...    preco=${price}
    ...    descricao=${description}
    ...    quantidade=${quantity}

    Create Session    api    ${API_BASE_URL}

    ${response}=    PUT On Session
    ...    api
    ...    /produtos/${product_id}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=${expected_status}

    RETURN    ${response}