final addCourt = """
  mutation addCourt(
    \$name: String!, 
    \$address: String!, 
    \$open_hour: String!, 
    \$closed_hour: String!,
    \$open_day: String!,
    \$closed_day: String!,
    \$price_per_hour: Int!,
    \$phone_number: String!,
    \$latitude: String!,
    \$longitude: String!,
    \$owner_id: String!,
    \$img1: String!,
    \$img2: String!,
    \$img3: String!,
    \$fas1: String!,
    \$fas2: String!,
  ){
    insert_court(
      objects: {
        name: \$name
        address: \$address
        open_hour: \$open_hour
        closed_hour: \$closed_hour
        open_day: \$open_day
        closed_day: \$closed_day
        price_per_hour: \$price_per_hour
        phone_number: \$phone_number
        latitude: \$latitude
        longitude: \$longitude
        owner_id: \$owner_id
        court_images: {
          data: [
            {name: \$img1}
            {name: \$img2}
            {name: \$img3}
          ]
        }
        court_facilities: {
          data: [
            {name: \$fas1}
            {name: \$fas2}
          ]
        }
      }
    ){
      affected_rows
    }
  }
""";