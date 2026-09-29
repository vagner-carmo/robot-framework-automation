*** Settings ***
Library    Collections
Resource   ../../resources/keywords/api_keywords.robot

*** Test Cases ***
User Should Be Created Successfully
    ${user}=    Create Random User

    ${response}=    Create User
    ...    ${user}[name]
    ...    ${user}[email]
    ...    ${user}[password]
    ...    ${user}[administrator]

    Status Should Be    201    ${response}

    ${response_body}=    Validate Response Is JSON    ${response}
    Validate Response Is Object    ${response_body}

    Validate Response Against Schema
    ...    ${response_body}
    ...    ${USER_CREATE_SUCCESS_SCHEMA}

    ${message}=    Validate Response Contains Message    ${response_body}
    Should Be Equal    ${message}    Cadastro realizado com sucesso

    Dictionary Should Contain Key    ${response_body}    _id

User Should Not Be Created With Duplicate Email
    ${user}=    Create Random User

    ${first_response}=    Create User
    ...    ${user}[name]
    ...    ${user}[email]
    ...    ${user}[password]
    ...    ${user}[administrator]

    Status Should Be    201    ${first_response}

    ${second_response}=    Create User
    ...    ${user}[name]
    ...    ${user}[email]
    ...    ${user}[password]
    ...    ${user}[administrator]
    ...    400

    Status Should Be    400    ${second_response}

    ${response_body}=    Validate Response Is JSON    ${second_response}
    Validate Response Is Object    ${response_body}

    Validate Response Against Schema
    ...    ${response_body}
    ...    ${USER_CREATE_ERROR_SCHEMA}

    Validate Response Contains Message    ${response_body}

User Should Not Be Created With Empty Required Fields
    ${response}=    Create User
    ...    ${EMPTY}
    ...    ${EMPTY}
    ...    ${EMPTY}
    ...    ${EMPTY}
    ...    400

    Status Should Be    400    ${response}

    ${response_body}=    Validate Response Is JSON    ${response}
    Validate Response Is Object    ${response_body}

    Validate Response Against Schema
    ...    ${response_body}
    ...    ${USER_CREATE_EMPTY_FIELDS_SCHEMA}

    Dictionary Should Contain Key    ${response_body}    nome
    Dictionary Should Contain Key    ${response_body}    email
    Dictionary Should Contain Key    ${response_body}    password
    Dictionary Should Contain Key    ${response_body}    administrador

User Should Be Retrieved Successfully
    ${user}    ${user_id}=    Create Random User And Return Id

    ${response}=    Get User    ${user_id}

    Status Should Be    200    ${response}

    ${response_body}=    Validate Response Is JSON    ${response}
    Validate Response Is Object    ${response_body}

    Validate Response Against Schema
    ...    ${response_body}
    ...    ${USER_GET_SUCCESS_SCHEMA}

    Should Be Equal    ${response_body}[_id]    ${user_id}
    Should Be Equal    ${response_body}[nome]    ${user}[name]
    Should Be Equal    ${response_body}[email]    ${user}[email]
    Should Be Equal    ${response_body}[password]    ${user}[password]
    Should Be Equal    ${response_body}[administrador]    ${user}[administrator]

All Users Should Be Retrieved Successfully
    ${first_user}    ${first_user_id}=    Create Random User And Return Id
    ${second_user}    ${second_user_id}=    Create Random User And Return Id

    ${response}=    Get All Users

    Status Should Be    200    ${response}

    ${response_body}=    Validate Response Is JSON    ${response}
    Validate Response Is Object    ${response_body}

    Validate Response Against Schema
    ...    ${response_body}
    ...    ${USER_GET_ALL_SCHEMA}

    ${users}=    Get From Dictionary    ${response_body}    usuarios

    ${user_ids}=    Evaluate    [user["_id"] for user in $users]

    Should Contain    ${user_ids}    ${first_user_id}
    Should Contain    ${user_ids}    ${second_user_id}

User Should Not Be Retrieved With Nonexistent Id
    ${nonexistent_id}=    FakerLibrary.Password    length=16    special_chars=False

    ${response}=    Get User    ${nonexistent_id}    400

    Status Should Be    400    ${response}

    ${response_body}=    Validate Response Is JSON    ${response}
    Validate Response Is Object    ${response_body}

    Validate Response Against Schema
    ...    ${response_body}
    ...    ${USER_GET_NOT_FOUND_SCHEMA}

    ${message}=    Validate Response Contains Message    ${response_body}
    Should Be Equal    ${message}    Usuário não encontrado

User Should Be Updated Successfully
    ${user}    ${user_id}=    Create Random User And Return Id

    ${updated_user}=    Create Random User

    ${update_response}=    Update User
    ...    ${user_id}
    ...    ${updated_user}[name]
    ...    ${updated_user}[email]
    ...    ${updated_user}[password]
    ...    ${updated_user}[administrator]

    Status Should Be    200    ${update_response}

    ${update_body}=    Validate Response Is JSON    ${update_response}
    Validate Response Is Object    ${update_body}

    Validate Response Against Schema
    ...    ${update_body}
    ...    ${USER_UPDATE_SUCCESS_SCHEMA}

    Validate Response Contains Message    ${update_body}

    ${get_response}=    Get User    ${user_id}

    Status Should Be    200    ${get_response}

    ${response_body}=    Validate Response Is JSON    ${get_response}
    Validate Response Is Object    ${response_body}

    Validate Response Against Schema
    ...    ${response_body}
    ...    ${USER_GET_SUCCESS_SCHEMA}

    Should Be Equal    ${response_body}[_id]    ${user_id}
    Should Be Equal    ${response_body}[nome]    ${updated_user}[name]
    Should Be Equal    ${response_body}[email]    ${updated_user}[email]
    Should Be Equal    ${response_body}[password]    ${updated_user}[password]
    Should Be Equal    ${response_body}[administrador]    ${updated_user}[administrator]

User Should Not Be Updated With Existing Email
    ${first_user}    ${first_user_id}=    Create Random User And Return Id
    ${second_user}    ${second_user_id}=    Create Random User And Return Id

    ${update_response}=    Update User
    ...    ${second_user_id}
    ...    ${second_user}[name]
    ...    ${first_user}[email]
    ...    ${second_user}[password]
    ...    ${second_user}[administrator]
    ...    400

    Status Should Be    400    ${update_response}

    ${response_body}=    Validate Response Is JSON    ${update_response}
    Validate Response Is Object    ${response_body}

    Validate Response Against Schema
    ...    ${response_body}
    ...    ${USER_CREATE_ERROR_SCHEMA}

    ${message}=    Validate Response Contains Message    ${response_body}
    Should Be Equal    ${message}    Este email já está sendo usado

User Should Be Deleted Successfully
    ${user}    ${user_id}=    Create Random User And Return Id

    ${delete_response}=    Delete User    ${user_id}

    Status Should Be    200    ${delete_response}

    ${delete_body}=    Validate Response Is JSON    ${delete_response}
    Validate Response Is Object    ${delete_body}

    Validate Response Against Schema
    ...    ${delete_body}
    ...    ${USER_DELETE_SUCCESS_SCHEMA}

    Validate Response Contains Message    ${delete_body}

    ${get_response}=    Get User    ${user_id}    400

    Status Should Be    400    ${get_response}

    ${get_body}=    Validate Response Is JSON    ${get_response}
    Validate Response Is Object    ${get_body}

    Validate Response Against Schema
    ...    ${get_body}
    ...    ${USER_GET_NOT_FOUND_SCHEMA}