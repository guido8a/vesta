package vesta

import groovy.sql.Sql

/**
 * Servicio para conexión con la base de datos
 */
class DbConnectionService {
    boolean transactional = false
    def dataSource

    /**
     * Devuelve la conexión a la base de datos
     */
    def getConnection() {
        Sql sql = new Sql(dataSource)
        return sql
    }

}
