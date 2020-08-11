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
      username
      created_at
      account_status
      docs_id
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
        bookings_aggregate(where: {booking_status: {_eq: "completed"}}){
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

final getCountBookingsBaseOnStatus = """
  query getCountBookingsBaseOnStatus(\$id: String!, \$status: String!){
    bookings_aggregate(where: {
      _and: [
        {court: {owner_id: {_eq: \$id}}}
        {booking_status: {_eq: \$status}}
      ]
    }){
      aggregate {
        count
      }
    }  
  }
""";

final String updateProfilePicture = """
  mutation updateProfilePicture(\$id: String!, \$profile_picture: String!){
    update_owners(where: {id: {_eq: \$id}} _set: {
      profile_picture: \$profile_picture
    }) {
      affected_rows
    }
  }
""";