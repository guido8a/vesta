dataSource {
    pooled = true
    driverClassName = "org.postgresql.Driver"
    dialect = org.hibernate.dialect.PostgreSQLDialect
}

// ver: http://grails.github.io/grails-howtos/en/performanceTuning.html
hibernate {
    cache.use_second_level_cache = false  //true por defecto
    cache.use_query_cache = false  //true por defecto, pero tarda mucho el hibernate
    cache.provider_class = 'net.sf.ehcache.hibernate.EhCacheProvider'
}
// environment specific settings
environments {
    development {
        dataSource {
            dbCreate = "update"
//            url = "jdbc:postgresql://10.0.0.2:5432/vesta_curso"
//            url = "jdbc:postgresql://10.0.0.2:5432/vesta"
//            url = "jdbc:postgresql://10.0.0.2:5432/vesta_corr1"  // desarrollo GP reformas y ajustes
//            url = "jdbc:postgresql://10.0.0.2:5432/vesta_prdc"
            url = "jdbc:postgresql://192.168.100.9:5432/vesta_prba"  //BD de yachay: vesta2016
            username = "postgres"
            password = "postgres"
        }
    }
    test {
        dataSource {
            dbCreate = "update"
            url = "jdbc:postgresql://10.0.0.3:5432/vesta"
            username = "postgres"
            password = "postgres"
        }
    }
    production {
        dataSource {
            dbCreate = "update"
            url = "jdbc:postgresql://127.0.0.1:5432/vesta"
            username = "postgres"
            password = "steinsgate"
        }
    }

    pruebas {
        dataSource {
            dbCreate = "update"
            url = "jdbc:postgresql://127.0.0.1:5432/vesta_prba"
            username = "postgres"
            password = "steinsgate"
        }
    }

    corrientes {
        dataSource {
            dbCreate = "update"
            url = "jdbc:postgresql://127.0.0.1:5432/vesta_corr"
            username = "postgres"
            password = "steinsgate"
        }

    }

}
