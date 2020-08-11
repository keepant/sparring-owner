final getAllBookings = """ 
  query getAllBookings(\$id: String!, \$status: String!){
    bookings(where: {_and: [
      {court: {owner_id: {_eq: \$id}}}
      {booking_status: {_eq: \$status}}
    ]}) {
      id
      date
      time_end
      time_start
      total_price
      booking_status
      order_id
      qty
      court {
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

final getBookingByCourt = """ 
  query getBookingByCourt(\$id: Int!, \$status: String!){
    court(where: {id: {_eq: \$id}}) {
      id
      name
      address
      court_images{
        id
        name
      }
      bookings(where: {booking_status: {_eq: \$status}}) {
        id
        date
        time_start
        time_end
        booking_status
        total_price
      }
    }
  }	
""";

final getBookingById = """
    query getBookingById(\$id: Int!){
      bookings (where: {id: {_eq: \$id}}){
        id
        date
        time_start
        time_end
        booking_status
        total_price
        order_id
        qty
    		court{
          id
          name
          address
 					phone_number
          latitude
          longitude
          price_per_hour
          court_images {
            id
            name
          }
        }
        user{
          id
          name
          email
          phone_number
          address
        }
      }
    }
""";