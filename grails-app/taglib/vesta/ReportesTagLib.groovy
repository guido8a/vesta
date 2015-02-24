package vesta

/**
 * Tags para facilitar la creación de reportes (HTML -> PDF)
 */
class ReportesTagLib {

    static namespace = 'rep'

//    static defaultEncodeAs = [taglib: 'html']
    //static encodeAsForTags = [tagName: [taglib:'html'], otherTagName: [taglib:'none']]

    /**
     * genera los estilos básicos para los reportes según la orientación deseada
     */
    def estilos = { attrs ->

        def pags = false
        if (attrs.pags == 1 || attrs.pags == "1" || attrs.pags == "true" || attrs.pags == true || attrs.pags == "si") {
            pags = true
        }
        if (!pags && attrs.pagTitle) {
            pags = true
        }

        if (!attrs.orientacion) {
            attrs.orientacion = "p"
        }
        def pOrientacion = attrs.orientacion.toString().toLowerCase()
        def orientacion = "portrait"
        def margenes = [
                top   : 3,
                right : 2,
                bottom: 3,
                left  : 2
        ]
        switch (pOrientacion) {
            case "l":
            case "landscape":
            case "horizontal":
            case "h":
                orientacion = "landscape"
                break;
        }

        def css = "<style type='text/css'>"
        css += "* {\n" +
                "    font-family   : 'PT Sans Narrow';\n" +
                "    font-size     : 11pt;\n" +
                "}"
        css += " @page {\n" +
                "    size          : A4 ${orientacion};\n" +
                "    margin-top    : ${margenes.top}cm;\n" +
                "    margin-right  : ${margenes.right}cm;\n" +
                "    margin-bottom : ${margenes.bottom}cm;\n" +
                "    margin-left   : ${margenes.left}cm;\n" +
                "}"
        css += "@page {\n" +
                "    @top-right {\n" +
                "        content : element(header);\n" +
                "    }\n" +
                "}"
        css += "@page {\n" +
                "    @bottom-right {\n" +
                "        content : element(footer);\n" +
                "    }\n" +
                "}"
        if (pags) {
            css += "@page {\n" +
                    "    @bottom-left { \n" +
                    "        content     : '${attrs.pagTitle ?: ''} pág.' counter(page) ' de ' counter(pages);\n" +
                    "        font-family : 'PT Sans Narrow';\n" +
                    "        font-size   : 8pt;" +
                    "        font-style  : italic\n" +
                    "    }\n" +
                    "}"
        }
        css += "#header{\n" +
                "    width      : 100%;\n" +
                "    text-align : right;\n" +
                "    position   : running(header);\n" +
                "}"
        css += "#footer{\n" +
                "    text-align : right;\n" +
                "    position   : running(footer);\n" +
                "    color      : #7D807F;\n" +
                "}"
        css += "@page{\n" +
                "    orphans    : 4;\n" +
                "    widows     : 2;\n" +
                "}"
        css += "table {\n" +
                "    page-break-inside : avoid;\n" +
                "}"
        css += ".tituloReporte{\n" +
                "    text-align     : center;\n" +
                "    text-transform : uppercase;\n" +
                "    font-family    : 'PT Sans';\n" +
                "    font-size      : 25pt;\n" +
                "    font-weight    : bold;\n" +
                "    color          : #17365D;\n" +
                "    border-bottom  : solid 2px #4F81BD;\n" +
                "}"
        css += ".numeracion {\n" +
                "    margin-top     : 1cm;\n" +
                "    margin-bottom  : 1cm;\n" +
                "    font-size      : 12.5pt;\n" +
                "    font-family    : 'PT Sans';\n" +
                "    color          : white;\n" +
                "    text-align     : center;\n" +
                "}"
        css += ".numeracion table {\n" +
                "    border-collapse : collapse;\n" +
                "    border          : solid 1px #C0C0C0;" +
                "    margin-left     : auto;\n" +
                "    margin-right    : auto;\n" +
                "}"
        css += ".numeracion table td {\n" +
                "    padding : 5px;\n" +
                "}"
        css += "</style>"

        out << raw(css)
    }

    /**
     * Muestra el header para los reportes
     * @param title el título del reporte
     */
    def headerReporte = { attrs ->
        def title = attrs.title ?: ""

        def h = 55

        def logoPath = resource(dir: 'images', file: 'logo-pdf-header.png')
        def html = ""

        html += '<div id="header">'
        html += "<img src='${logoPath}' style='height:${h}px;'/>"
        html += '</div>'
        if (title) {
            html += "<div class='tituloReporte'>"
            html += title
            html += '</div>'
        }

        html += "<div class='numeracion'>"
        html += "<table border='1'>"
        html += "<tr>"
        html += "<td style='background: #0F243E;'>Form. GPE-DPI-01</td>"
        html += "<td style='background: #008080;'>Numeración:</td>"
        html += "<td style='background: #008080;'>2015-${attrs.unidad ?: ''}</td>"
        html += "<td style='background: #008080;'>No. ${attrs.numero ?: ''}</td>"
        html += "</tr>"
        html += "</table>"
        html += "</div>"

        out << raw(html)
    }

    /**
     * Muestra el footer para los reportes
     */
    def footerReporte = { attrs ->
        def html = ""
        def h = 75
        def logoPath = resource(dir: 'images', file: 'logo-pdf-footer.png')

        html += '<div id="footer">'
        html += "<img src='${logoPath}' style='height:${h}px; float:right; margin-left: 1cm; margin-bottom: 1cm;'/>"
        html += "<div style='float:right; font-size:8pt;'>"
        html += "Amazonas N26-146 y La Niña<br/>"
        html += "Telf. +(593)2304 9100<br/>"
        html += "Quito - Ecuador<br/>"
        html += "www.yachay.gob.ec<br/>"
        html += "</div>"
        html += "</div>"

        out << raw(html)
    }

    def headerFooter = { attrs ->
        attrs.title = attrs.title ?: ""
        def header = headerReporte(attrs)
        def footer = footerReporte(attrs)

        out << header << footer
    }

}
