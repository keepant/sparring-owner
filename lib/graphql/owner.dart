final String getOwner = """
  query getOwner(\$id: String!){
    owners(where: {id: {_eq: \$id}}) {
      id
      name
      email
      sex
      phone_number
      address
      profile_picture
      id_card_number
      photo_id
      selfie_with_id
      username
      is_verified
      created_at
    }
  }
""";