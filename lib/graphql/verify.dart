final updateIdCard = """
  mutation updateIdCard(\$id: uuid!, \$file: String!){
    action: update_owner_docs(
      where: {id: {_eq: \$id}},
      _set: {
        id_card: \$file
      }
    ){
      affected_rows
    }
  }
""";

final updatePhoto = """
  mutation updatePhoto(\$id: uuid!, \$file: String!){
    action: update_owner_docs(
      where: {id: {_eq: \$id}},
      _set: {
        photo: \$file
      }
    ){
      affected_rows
    }
  }
""";

final updateSelfieAndAccountStatus = """
  mutation updateAccountStatus(\$idUser: String!, \$idDocs: uuid!, \$file: String!){
    update_owners(
      where: {id: {_eq: \$idUser}},
      _set: {
        account_status: "process"
      }
    ){
      affected_rows
    }
    update_owner_docs(
      where: {id: {_eq: \$idDocs}},
      _set: {
        selfie_with_id: \$file
      }
    ){
      affected_rows
    }
  }
""";