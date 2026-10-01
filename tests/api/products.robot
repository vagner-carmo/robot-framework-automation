*** Settings ***
Resource    ../../resources/keywords/api_keywords.robot
Resource    ../../resources/variables/api_variables.robot


*** Test Cases ***
Product Should Be Created Successfully
    [Documentation]    Verifies that a product can be created successfully.
    [Tags]    api    products    smoke    regression
    ${token}=    Create Random Admin User And Login

    ${product}    ${response}=    Create Random Product    ${token}

    Status Should Be    201    ${response}

    ${response_body}=    Validate Response Is JSON    ${response}
    Validate Response Is Object    ${response_body}

    Validate Response Against Schema
    ...    ${response_body}
    ...    ${PRODUCT_CREATE_SUCCESS_SCHEMA}

    ${message}=    Validate Response Contains Message    ${response_body}
    Should Be Equal    ${message}    Cadastro realizado com sucesso

    ${product_id}=    Get From Dictionary    ${response_body}    _id
    Should Not Be Empty    ${product_id}

Product Should Not Be Created With Duplicate Name
    [Documentation]    Verifies that a product cannot be created with an existing name.
    [Tags]    api    products    regression
    ${token}=    Create Random Admin User And Login

    ${first_product}    ${first_response}=    Create Random Product    ${token}

    Status Should Be    201    ${first_response}

    ${first_body}=    Validate Response Is JSON    ${first_response}
    Validate Response Is Object    ${first_body}

    Validate Response Against Schema
    ...    ${first_body}
    ...    ${PRODUCT_CREATE_SUCCESS_SCHEMA}

    ${second_response}=    Create Product
    ...    ${first_product}[name]
    ...    ${first_product}[price]
    ...    ${first_product}[description]
    ...    ${first_product}[quantity]
    ...    ${token}
    ...    400

    Status Should Be    400    ${second_response}

    ${response_body}=    Validate Response Is JSON    ${second_response}
    Validate Response Is Object    ${response_body}

    Validate Response Against Schema
    ...    ${response_body}
    ...    ${PRODUCT_CREATE_ERROR_SCHEMA}

    ${message}=    Validate Response Contains Message    ${response_body}
    Should Be Equal    ${message}    Já existe produto com esse nome

Product Should Not Be Created With Invalid Token
    [Documentation]    Verifies that a product cannot be created with an invalid token.
    [Tags]    api    products    regression
    ${invalid_token}=    FakerLibrary.Password    length=32    special_chars=False

    ${product}    ${response}=    Create Random Product
    ...    Bearer ${invalid_token}
    ...    401

    Status Should Be    401    ${response}

    ${response_body}=    Validate Response Is JSON    ${response}
    Validate Response Is Object    ${response_body}

    Validate Response Against Schema
    ...    ${response_body}
    ...    ${PRODUCT_CREATE_INVALID_TOKEN_SCHEMA}

    ${message}=    Validate Response Contains Message    ${response_body}
    Should Be Equal
    ...    ${message}
    ...    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

All Products Should Be Retrieved Successfully
    [Documentation]    Verifies that all products can be retrieved successfully.
    [Tags]    api    products    regression
    ${token}=    Create Random Admin User And Login

    ${first_product}    ${first_response}=    Create Random Product    ${token}
    ${second_product}    ${second_response}=    Create Random Product    ${token}

    Status Should Be    201    ${first_response}
    Status Should Be    201    ${second_response}

    ${first_body}=    Validate Response Is JSON    ${first_response}
    Validate Response Is Object    ${first_body}

    Validate Response Against Schema
    ...    ${first_body}
    ...    ${PRODUCT_CREATE_SUCCESS_SCHEMA}

    ${second_body}=    Validate Response Is JSON    ${second_response}
    Validate Response Is Object    ${second_body}

    Validate Response Against Schema
    ...    ${second_body}
    ...    ${PRODUCT_CREATE_SUCCESS_SCHEMA}

    ${first_product_id}=    Get From Dictionary    ${first_body}    _id
    ${second_product_id}=    Get From Dictionary    ${second_body}    _id

    ${response}=    Get All Products

    Status Should Be    200    ${response}

    ${response_body}=    Validate Response Is JSON    ${response}
    Validate Response Is Object    ${response_body}

    Validate Response Against Schema
    ...    ${response_body}
    ...    ${PRODUCT_GET_ALL_SCHEMA}

    ${products}=    Get From Dictionary    ${response_body}    produtos

    ${product_ids}=    Evaluate    [product["_id"] for product in $products]

    Should Contain    ${product_ids}    ${first_product_id}
    Should Contain    ${product_ids}    ${second_product_id}

Product Should Be Retrieved Successfully
    [Documentation]    Verifies that a product can be retrieved successfully by its ID.
    [Tags]    api    products    smoke    regression
    ${token}=    Create Random Admin User And Login

    ${product}    ${create_response}=    Create Random Product    ${token}

    Status Should Be    201    ${create_response}

    ${create_body}=    Validate Response Is JSON    ${create_response}
    Validate Response Is Object    ${create_body}

    Validate Response Against Schema
    ...    ${create_body}
    ...    ${PRODUCT_CREATE_SUCCESS_SCHEMA}

    ${product_id}=    Get From Dictionary    ${create_body}    _id

    ${response}=    Get Product    ${product_id}

    Status Should Be    200    ${response}

    ${response_body}=    Validate Response Is JSON    ${response}
    Validate Response Is Object    ${response_body}

    Validate Response Against Schema
    ...    ${response_body}
    ...    ${PRODUCT_GET_SUCCESS_SCHEMA}

    Should Be Equal    ${response_body}[_id]    ${product_id}
    Should Be Equal    ${response_body}[nome]    ${product}[name]
    Should Be Equal    ${response_body}[preco]    ${product}[price]
    Should Be Equal    ${response_body}[descricao]    ${product}[description]
    Should Be Equal    ${response_body}[quantidade]    ${product}[quantity]

Product Should Not Be Retrieved With Invalid Id
    [Documentation]    Verifies that a product cannot be retrieved with an invalid ID.
    [Tags]    api    products    regression
    ${invalid_id}=    FakerLibrary.Password    length=16    special_chars=False

    ${response}=    Get Product
    ...    ${invalid_id}
    ...    400

    Status Should Be    400    ${response}

    ${response_body}=    Validate Response Is JSON    ${response}
    Validate Response Is Object    ${response_body}

    Validate Response Against Schema
    ...    ${response_body}
    ...    ${PRODUCT_GET_NOT_FOUND_SCHEMA}

    ${message}=    Validate Response Contains Message    ${response_body}
    Should Be Equal    ${message}    Produto não encontrado

Product Should Be Deleted Successfully
    [Documentation]    Verifies that a product can be deleted successfully.
    [Tags]    api    products    regression
    ${token}=    Create Random Admin User And Login

    ${product}    ${create_response}=    Create Random Product    ${token}

    Status Should Be    201    ${create_response}

    ${create_body}=    Validate Response Is JSON    ${create_response}
    Validate Response Is Object    ${create_body}

    Validate Response Against Schema
    ...    ${create_body}
    ...    ${PRODUCT_CREATE_SUCCESS_SCHEMA}

    ${product_id}=    Get From Dictionary    ${create_body}    _id

    ${delete_response}=    Delete Product
    ...    ${product_id}
    ...    ${token}

    Status Should Be    200    ${delete_response}

    ${delete_body}=    Validate Response Is JSON    ${delete_response}
    Validate Response Is Object    ${delete_body}

    Validate Response Against Schema
    ...    ${delete_body}
    ...    ${PRODUCT_DELETE_SUCCESS_SCHEMA}

    ${message}=    Validate Response Contains Message    ${delete_body}
    Should Not Be Empty    ${message}

    ${get_response}=    Get Product
    ...    ${product_id}
    ...    400

    Status Should Be    400    ${get_response}

    ${get_body}=    Validate Response Is JSON    ${get_response}
    Validate Response Is Object    ${get_body}

    Validate Response Against Schema
    ...    ${get_body}
    ...    ${PRODUCT_GET_NOT_FOUND_SCHEMA}

    ${get_message}=    Validate Response Contains Message    ${get_body}
    Should Be Equal    ${get_message}    Produto não encontrado

Product Should Not Be Deleted With Invalid Token
    [Documentation]    Verifies that a product cannot be deleted with an invalid token.
    [Tags]    api    products    regression
    ${token}=    Create Random Admin User And Login

    ${product}    ${create_response}=    Create Random Product    ${token}

    Status Should Be    201    ${create_response}

    ${create_body}=    Validate Response Is JSON    ${create_response}
    Validate Response Is Object    ${create_body}

    Validate Response Against Schema
    ...    ${create_body}
    ...    ${PRODUCT_CREATE_SUCCESS_SCHEMA}

    ${product_id}=    Get From Dictionary    ${create_body}    _id

    ${invalid_token}=    FakerLibrary.Password
    ...    length=32
    ...    special_chars=False

    ${delete_response}=    Delete Product
    ...    ${product_id}
    ...    Bearer ${invalid_token}
    ...    401

    Status Should Be    401    ${delete_response}

    ${response_body}=    Validate Response Is JSON    ${delete_response}
    Validate Response Is Object    ${response_body}

    Validate Response Against Schema
    ...    ${response_body}
    ...    ${PRODUCT_DELETE_INVALID_TOKEN_SCHEMA}

    ${message}=    Validate Response Contains Message    ${response_body}

    Should Be Equal
    ...    ${message}
    ...    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

    ${get_response}=    Get Product    ${product_id}

    Status Should Be    200    ${get_response}

    ${get_body}=    Validate Response Is JSON    ${get_response}
    Validate Response Is Object    ${get_body}

    Validate Response Against Schema
    ...    ${get_body}
    ...    ${PRODUCT_GET_SUCCESS_SCHEMA}

    Should Be Equal    ${get_body}[_id]    ${product_id}

Product Should Not Be Deleted When Associated With Cart
    [Documentation]    Verifies that a product associated with a cart cannot be deleted.
    [Tags]    api    products    regression
    ${token}=    Create Random Admin User And Login

    ${product}    ${create_response}=    Create Random Product    ${token}

    Status Should Be    201    ${create_response}

    ${create_body}=    Validate Response Is JSON    ${create_response}
    Validate Response Is Object    ${create_body}

    Validate Response Against Schema
    ...    ${create_body}
    ...    ${PRODUCT_CREATE_SUCCESS_SCHEMA}

    ${product_id}=    Get From Dictionary    ${create_body}    _id

    ${cart_response}=    Create Cart
    ...    ${product_id}
    ...    1
    ...    ${token}

    Status Should Be    201    ${cart_response}

    ${cart_body}=    Validate Response Is JSON    ${cart_response}
    Validate Response Is Object    ${cart_body}

    ${delete_response}=    Delete Product
    ...    ${product_id}
    ...    ${token}
    ...    400

    Status Should Be    400    ${delete_response}

    ${response_body}=    Validate Response Is JSON    ${delete_response}
    Validate Response Is Object    ${response_body}

    Validate Response Against Schema
    ...    ${response_body}
    ...    ${PRODUCT_DELETE_CART_ERROR_SCHEMA}

    ${message}=    Validate Response Contains Message    ${response_body}
    Should Be Equal    ${message}    Não é permitido excluir produto que faz parte de carrinho

    ${cart_ids}=    Get From Dictionary    ${response_body}    idCarrinhos
    Should Not Be Empty    ${cart_ids}

    ${get_response}=    Get Product    ${product_id}

    Status Should Be    200    ${get_response}

    ${get_body}=    Validate Response Is JSON    ${get_response}
    Validate Response Is Object    ${get_body}

    Validate Response Against Schema
    ...    ${get_body}
    ...    ${PRODUCT_GET_SUCCESS_SCHEMA}

    Should Be Equal    ${get_body}[_id]    ${product_id}

Product Should Be Updated Successfully
    [Documentation]    Verifies that a product can be updated successfully.
    [Tags]    api    products    regression
    ${token}=    Create Random Admin User And Login

    ${product}    ${create_response}=    Create Random Product    ${token}

    Status Should Be    201    ${create_response}

    ${create_body}=    Validate Response Is JSON    ${create_response}
    Validate Response Is Object    ${create_body}
    Validate Response Against Schema
    ...    ${create_body}
    ...    ${PRODUCT_CREATE_SUCCESS_SCHEMA}

    ${product_id}=    Get From Dictionary    ${create_body}    _id

    ${new_name}=    FakerLibrary.Name
    ${new_description}=    FakerLibrary.Sentence
    ${new_price}=    FakerLibrary.Random Int    min=1    max=1000
    ${new_quantity}=    FakerLibrary.Random Int    min=1    max=100

    ${update_response}=    Update Product
    ...    ${product_id}
    ...    ${new_name}
    ...    ${new_price}
    ...    ${new_description}
    ...    ${new_quantity}
    ...    ${token}

    Status Should Be    200    ${update_response}

    ${response_body}=    Validate Response Is JSON    ${update_response}
    Validate Response Is Object    ${response_body}
    Validate Response Against Schema
    ...    ${response_body}
    ...    ${PRODUCT_UPDATE_SUCCESS_SCHEMA}

    ${message}=    Validate Response Contains Message    ${response_body}
    Should Be Equal    ${message}    Registro alterado com sucesso

    ${get_response}=    Get Product    ${product_id}

    Status Should Be    200    ${get_response}

    ${get_body}=    Validate Response Is JSON    ${get_response}
    Validate Response Is Object    ${get_body}
    Validate Response Against Schema
    ...    ${get_body}
    ...    ${PRODUCT_GET_SUCCESS_SCHEMA}

    Should Be Equal    ${get_body}[_id]    ${product_id}
    Should Be Equal    ${get_body}[nome]    ${new_name}
    Should Be Equal As Numbers    ${get_body}[preco]    ${new_price}
    Should Be Equal    ${get_body}[descricao]    ${new_description}
    Should Be Equal As Numbers    ${get_body}[quantidade]    ${new_quantity}

Product Should Not Be Updated With Duplicate Name
    [Documentation]    Verifies that a product cannot be updated with an existing name.
    [Tags]    api    products    regression
    ${token}=    Create Random Admin User And Login

    ${first_product}    ${first_response}=    Create Random Product    ${token}

    Status Should Be    201    ${first_response}

    ${first_body}=    Validate Response Is JSON    ${first_response}
    Validate Response Is Object    ${first_body}
    Validate Response Against Schema
    ...    ${first_body}
    ...    ${PRODUCT_CREATE_SUCCESS_SCHEMA}

    ${first_product_id}=    Get From Dictionary    ${first_body}    _id

    ${second_product}    ${second_response}=    Create Random Product    ${token}

    Status Should Be    201    ${second_response}

    ${second_body}=    Validate Response Is JSON    ${second_response}
    Validate Response Is Object    ${second_body}
    Validate Response Against Schema
    ...    ${second_body}
    ...    ${PRODUCT_CREATE_SUCCESS_SCHEMA}

    ${second_product_id}=    Get From Dictionary    ${second_body}    _id

    ${update_response}=    Update Product
    ...    ${second_product_id}
    ...    ${first_product}[name]
    ...    ${second_product}[price]
    ...    ${second_product}[description]
    ...    ${second_product}[quantity]
    ...    ${token}
    ...    400

    Status Should Be    400    ${update_response}

    ${response_body}=    Validate Response Is JSON    ${update_response}
    Validate Response Is Object    ${response_body}
    Validate Response Against Schema
    ...    ${response_body}
    ...    ${PRODUCT_UPDATE_DUPLICATE_NAME_SCHEMA}

    ${message}=    Validate Response Contains Message    ${response_body}
    Should Be Equal    ${message}    Já existe produto com esse nome

Product Should Not Be Updated With Invalid Token
    [Documentation]    Verifies that a product cannot be updated with an invalid token.
    [Tags]    api    products    regression
    ${token}=    Create Random Admin User And Login

    ${product}    ${create_response}=    Create Random Product    ${token}

    Status Should Be    201    ${create_response}

    ${create_body}=    Validate Response Is JSON    ${create_response}
    Validate Response Is Object    ${create_body}
    Validate Response Against Schema
    ...    ${create_body}
    ...    ${PRODUCT_CREATE_SUCCESS_SCHEMA}

    ${product_id}=    Get From Dictionary    ${create_body}    _id

    ${invalid_token}=    FakerLibrary.Password    length=32    special_chars=False

    ${new_name}=    FakerLibrary.Name
    ${new_description}=    FakerLibrary.Sentence
    ${new_price}=    FakerLibrary.Random Int    min=1    max=1000
    ${new_quantity}=    FakerLibrary.Random Int    min=1    max=100

    ${update_response}=    Update Product
    ...    ${product_id}
    ...    ${new_name}
    ...    ${new_price}
    ...    ${new_description}
    ...    ${new_quantity}
    ...    Bearer ${invalid_token}
    ...    401

    Status Should Be    401    ${update_response}

    ${response_body}=    Validate Response Is JSON    ${update_response}
    Validate Response Is Object    ${response_body}
    Validate Response Against Schema
    ...    ${response_body}
    ...    ${PRODUCT_UPDATE_INVALID_TOKEN_SCHEMA}

    ${message}=    Validate Response Contains Message    ${response_body}
    Should Be Equal    ${message}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

    ${get_response}=    Get Product    ${product_id}

    Status Should Be    200    ${get_response}

    ${get_body}=    Validate Response Is JSON    ${get_response}
    Validate Response Is Object    ${get_body}
    Validate Response Against Schema
    ...    ${get_body}
    ...    ${PRODUCT_GET_SUCCESS_SCHEMA}

    Should Be Equal    ${get_body}[_id]    ${product_id}
    Should Be Equal    ${get_body}[nome]    ${product}[name]
    Should Be Equal As Numbers    ${get_body}[preco]    ${product}[price]
    Should Be Equal    ${get_body}[descricao]    ${product}[description]
    Should Be Equal As Numbers    ${get_body}[quantidade]    ${product}[quantity]