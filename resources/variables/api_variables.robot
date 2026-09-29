*** Variables ***
${API_BASE_URL}    https://serverest.dev

${LOGIN_SUCCESS_SCHEMA}             ${EXECDIR}/resources/schemas/login/login_success.json
${LOGIN_INVALID_SCHEMA}             ${EXECDIR}/resources/schemas/login/login_invalid_credentials.json
${LOGIN_EMPTY_FIELDS_SCHEMA}        ${EXECDIR}/resources/schemas/login/login_empty_fields.json

${USER_CREATE_SUCCESS_SCHEMA}       ${EXECDIR}/resources/schemas/users/create_success.json
${USER_CREATE_ERROR_SCHEMA}         ${EXECDIR}/resources/schemas/users/create_error.json
${USER_GET_SUCCESS_SCHEMA}          ${EXECDIR}/resources/schemas/users/get_success.json
${USER_GET_ALL_SCHEMA}              ${EXECDIR}/resources/schemas/users/get_all_success.json
${USER_GET_NOT_FOUND_SCHEMA}        ${EXECDIR}/resources/schemas/users/get_not_found.json
${USER_UPDATE_SUCCESS_SCHEMA}       ${EXECDIR}/resources/schemas/users/update_success.json
${USER_DELETE_SUCCESS_SCHEMA}       ${EXECDIR}/resources/schemas/users/delete_success.json
${USER_CREATE_EMPTY_FIELDS_SCHEMA}    ${EXECDIR}/resources/schemas/users/create_empty_fields.json