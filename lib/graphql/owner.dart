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
      account_status
    }
  }
""";

final String updateOwner = """
  mutation updateOwner(\$id: String!, \$name: String!, \$sex: String!, \$phone: String!, \$address: String!){
    action: update_owners(
      where: { id: {_eq: \$id}}, 
      _set: {
        name: \$name,
        sex: \$sex,
        phone_number: \$phone,
        address: \$address,
      }
    ) {
      affected_rows
    }
  }
""";

final getTotalIncome = """
  query getTotalIncome(\$id: String!){
    owners(where: {id: {_eq: \$id}}) {
      courts {
        bookings_aggregate{
          aggregate{
            sum{
              total_price
            }
          }
        }
      }
    }
  }
""";

final getCountCourt = """
  query getCountCourt(\$id: String!){
    owners(where: {id: {_eq: \$id}}) {
      courts_aggregate {
        aggregate {
          count
        }
      }
    }
  }
""";

final getOwnerCourt = """
  query getOwnerCourt(\$id: String!){
    owners(where: {id: {_eq: \$id}}) {
      courts{
        id
        name
        address
        court_images{
          id
          name
        }
      }
    }
  }
""";

final getCountBookings = """
  query getCountBookings(\$id: String!){
    owners(where: {id: {_eq: \$id}}) {
      courts{
        bookings_aggregate{
          aggregate {
            count
          }
        }
      }
    }
  }
""";