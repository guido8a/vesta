package vesta.utilitarios

class DescargasController extends vesta.seguridad.Shield {

    def manualAdmn() {
        def filePath = "manual del usuario - administracion.pdf"
        def path = servletContext.getRealPath("/") + File.separatorChar + filePath
        def file = new File(path)
        def b = file.getBytes()
        response.setContentType('pdf')
        response.setHeader("Content-disposition", "attachment; filename=" + filePath)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def manualAvales() {
        def filePath = "manual de usuario - avales.pdf"
        def path = servletContext.getRealPath("/") + File.separatorChar + filePath
        def file = new File(path)
        def b = file.getBytes()
        response.setContentType('pdf')
        response.setHeader("Content-disposition", "attachment; filename=" + filePath)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def manualReformas() {
        def filePath = "manual del usuario - reformas.pdf"
        def path = servletContext.getRealPath("/") + File.separatorChar + filePath
        def file = new File(path)
        def b = file.getBytes()
        response.setContentType('pdf')
        response.setHeader("Content-disposition", "attachment; filename=" + filePath)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def manualAjustes() {
        def filePath = "manual del usuario - ajustes.pdf"
        def path = servletContext.getRealPath("/") + File.separatorChar + filePath
        def file = new File(path)
        def b = file.getBytes()
        response.setContentType('pdf')
        response.setHeader("Content-disposition", "attachment; filename=" + filePath)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def manualProy() {
        def filePath = "manual del usuario - proyectos.pdf"
        def path = servletContext.getRealPath("/") + File.separatorChar + filePath
        def file = new File(path)
        def b = file.getBytes()
        response.setContentType('pdf')
        response.setHeader("Content-disposition", "attachment; filename=" + filePath)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def manualReportes() {
        def filePath = "manual del usuario - reportes.pdf"
        def path = servletContext.getRealPath("/") + File.separatorChar + filePath
        def file = new File(path)
        def b = file.getBytes()
        response.setContentType('pdf')
        response.setHeader("Content-disposition", "attachment; filename=" + filePath)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }


} //fin controller
