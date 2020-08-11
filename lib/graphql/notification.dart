final String getNotif = """
  query getNotif(\$user_id: String!, \$created_at: timestamptz!){
    notifications(
      where: {
        _and: [
          {
            _or: [
              {segment: {_eq: \$user_id}}
              {segment: {_eq: "all"}}
            ]
          }
          {
            created_at: {_gte: \$created_at}
          }
          {
            app: {_eq: "owner"}
          }
        ]
      } order_by: {created_at: desc}
    ) {
      id
      title
      content
      app
      created_at
      segment
    }
  }
""";