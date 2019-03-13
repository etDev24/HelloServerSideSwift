import FluentSQLite
import Vapor
import FluentPostgreSQL

struct ProductionDBConfig {
    static let hostName = "ec2-23-21-128-35.compute-1.amazonaws.com"
    static let database = "df0oq560t871fj"
    static let user = "ombincjjukuspa"
    static let password = "a182906dce9e671d41e049d69cc407193881a2e1e0109a564f066c243c590398"
    static let uri = "postgres://ombincjjukuspa:a182906dce9e671d41e049d69cc407193881a2e1e0109a564f066c243c590398@ec2-23-21-128-35.compute-1.amazonaws.com:5432/df0oq560t871fj"
    static let port = 5432
    static let cli = "heroku pg:psql postgresql-fluffy-74254 --app helloswiftdemo"
}

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    
    
    //SQLite configurations
    /*
     try services.register(FluentSQLiteProvider())
     
     /// Register routes to the router
     let router = EngineRouter.default()
     try routes(router)
     services.register(router, as: Router.self)
     
     /// Register middleware
     var middlewares = MiddlewareConfig() // Create _empty_ middleware config
     /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
     middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
     services.register(middlewares)
     
     // Configure a SQLite database
     let sqlite = try SQLiteDatabase(storage: .file(path: "/Users/apple/Documents/Projects/HelloServerSideSwift/project.db"))
     /// Register the configured SQLite database to the database config.
     var databases = DatabasesConfig()
     databases.add(database: sqlite, as: .sqlite)
     services.register(databases)
     
     /// Configure migrations
     var migrations = MigrationConfig()
     migrations.add(model: User.self, database: .sqlite)
     migrations.add(model: Product.self, database: .sqlite)
     migrations.add(model: Booking.self, database: .sqlite)
     services.register(migrations)
    */
    
    try services.register(PostgreSQLProvider())
    
    // Configure a Postgres database
    var databases = DatabasesConfig()
    let databaseConfig: PostgreSQLDatabaseConfig
    if let url = Environment.get("DATABASE_URL") {
        databaseConfig = (try PostgreSQLDatabaseConfig(url: url))
    }
    else {
        databaseConfig = PostgreSQLDatabaseConfig(hostname: ProductionDBConfig.hostName, port: ProductionDBConfig.port, username: ProductionDBConfig.user, database: ProductionDBConfig.database, password: ProductionDBConfig.password)
//        databaseConfig = PostgreSQLDatabaseConfig(hostname: "localhost", port: 5432, username: "anapaix", database: "postgrestutorial", password: nil)
        
    }
    let database = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .psql)
    services.register(databases)
    
    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Product.self, database: .psql)
    migrations.add(model: Booking.self, database: .psql)
    services.register(migrations)

}
