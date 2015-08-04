package vesta

class ImportsTagLib {
//    static defaultEncodeAs = 'html'
//    static encodeAsForTags = [tagName: 'raw']
    static namespace = 'imp'

    def favicon = { attrs ->
        /*
        <link rel="apple-touch-icon" sizes="57x57" href="/apple-touch-icon-57x57.png">
        <link rel="apple-touch-icon" sizes="114x114" href="/apple-touch-icon-114x114.png">
        <link rel="apple-touch-icon" sizes="72x72" href="/apple-touch-icon-72x72.png">
        <link rel="apple-touch-icon" sizes="144x144" href="/apple-touch-icon-144x144.png">
        <link rel="apple-touch-icon" sizes="60x60" href="/apple-touch-icon-60x60.png">
        <link rel="apple-touch-icon" sizes="120x120" href="/apple-touch-icon-120x120.png">
        <link rel="apple-touch-icon" sizes="76x76" href="/apple-touch-icon-76x76.png">
        <link rel="apple-touch-icon" sizes="152x152" href="/apple-touch-icon-152x152.png">
        <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon-180x180.png">
        <meta name="apple-mobile-web-app-title" content="vesta">
        <link rel="icon" type="image/png" href="/favicon-192x192.png" sizes="192x192">
        <link rel="icon" type="image/png" href="/favicon-160x160.png" sizes="160x160">
        <link rel="icon" type="image/png" href="/favicon-96x96.png" sizes="96x96">
        <link rel="icon" type="image/png" href="/favicon-16x16.png" sizes="16x16">
        <link rel="icon" type="image/png" href="/favicon-32x32.png" sizes="32x32">
        <meta name="msapplication-TileColor" content="#1f3a78">
        <meta name="msapplication-TileImage" content="/mstile-144x144.png">
        <meta name="application-name" content="vesta">
         */

        def favicons = ""

        favicons += "<link rel='apple-touch-icon' sizes='57x57' href='${resource(dir: 'images/favicons', file: 'apple-touch-icon-57x57.png')}'>"
        favicons += "<link rel='apple-touch-icon' sizes='114x114' href='${resource(dir: 'images/favicons', file: 'apple-touch-icon-114x114.png')}'>"
        favicons += "<link rel='apple-touch-icon' sizes='72x72' href='${resource(dir: 'images/favicons', file: 'apple-touch-icon-72x72.png')}'>"
        favicons += "<link rel='apple-touch-icon' sizes='144x144' href='${resource(dir: 'images/favicons', file: 'apple-touch-icon-144x144.png')}'>"
        favicons += "<link rel='apple-touch-icon' sizes='60x60' href='${resource(dir: 'images/favicons', file: 'apple-touch-icon-60x60.png')}'>"
        favicons += "<link rel='apple-touch-icon' sizes='120x120' href='${resource(dir: 'images/favicons', file: 'apple-touch-icon-120x120.png')}'>"
        favicons += "<link rel='apple-touch-icon' sizes='76x76' href='${resource(dir: 'images/favicons', file: 'apple-touch-icon-76x76.png')}'>"
        favicons += "<link rel='apple-touch-icon' sizes='152x152' href='${resource(dir: 'images/favicons', file: 'apple-touch-icon-152x152.png')}'>"
        favicons += "<link rel='apple-touch-icon' sizes='180x180' href='${resource(dir: 'images/favicons', file: 'apple-touch-icon-180x180.png')}'>"
        favicons += "<meta name='apple-mobile-web-app-title' content='vesta'>"
        favicons += "<link rel='icon' type='image/png' href='${resource(dir: 'images/favicons', file: 'favicon-192x192.png')}' sizes='192x192'>"
        favicons += "<link rel='icon' type='image/png' href='${resource(dir: 'images/favicons', file: 'favicon-160x160.png')}' sizes='160x160'>"
        favicons += "<link rel='icon' type='image/png' href='${resource(dir: 'images/favicons', file: 'favicon-96x96.png')}' sizes='96x96'>"
        favicons += "<link rel='icon' type='image/png' href='${resource(dir: 'images/favicons', file: 'favicon-16x16.png')}' sizes='16x16'>"
        favicons += "<link rel='icon' type='image/png' href='${resource(dir: 'images/favicons', file: 'favicon-32x32.png')}' sizes='32x32'>"
        favicons += "<meta name='msapplication-TileColor' content='#1f3a78'>"
        favicons += "<meta name='msapplication-TileImage' content='${resource(dir: 'images/favicons', file: 'mstile-144x144.png')}'>"
        favicons += "<meta name='application-name' content='vesta'>"

        out << favicons
    }

    def css = { attrs ->
        def bootstrapTheme = attrs.bootstrap ?: "theme"

        // Bootstrap
        def text = " <link href=\"${resource(dir: 'bootstrap-3.3.2/dist/css', file: 'bootstrap.css')}\" rel=\"stylesheet\">\n"
        text += "    <link href=\"${resource(dir: 'bootstrap-3.3.2/dist/css', file: 'bootstrap-' + bootstrapTheme + '.min.css')}\" rel=\"stylesheet\">\n"
        // JQuery
        text += "    <link href=\"${resource(dir: 'js/jquery-ui-1.11.2', file: 'jquery-ui.min.css')}\" rel=\"stylesheet\">\n"
        text += "    <link href=\"${resource(dir: 'js/jquery-ui-1.11.2', file: 'jquery-ui.structure.min.css')}\" rel=\"stylesheet\">\n"
        text += "    <link href=\"${resource(dir: 'js/jquery-ui-1.11.2', file: 'jquery-ui.theme.min.css')}\" rel=\"stylesheet\">\n"
        // FontAwesome
        text += "    <link href=\"${resource(dir: 'fonts/font-awesome-4.4.0/css', file: 'font-awesome.min.css')}\" rel=\"stylesheet\">"
        // MFizz
        text += "    <link href=\"${resource(dir: 'fonts/font-mfizz-1.2', file: 'font-mfizz.css')}\" rel=\"stylesheet\">"

        //Banner
        text += "    <link href=\"${resource(dir: 'css/custom', file: 'banner.css')}\" rel=\"stylesheet\">"
        //Sticky footer
        text += "    <link href=\"${resource(dir: 'css/custom', file: 'sticky-footer.css')}\" rel=\"stylesheet\">"

        // CUSTOM
        text += "    <link href=\"${resource(dir: 'css/custom', file: 'custom.css')}\" rel=\"stylesheet\">"
        text += "    <link href=\"${resource(dir: 'css/custom', file: 'modals.css')}\" rel=\"stylesheet\">"
        text += "    <link href=\"${resource(dir: 'css/custom', file: 'tablas.css')}\" rel=\"stylesheet\">"
        text += "    <link href=\"${resource(dir: 'css/custom', file: 'inputs.css')}\" rel=\"stylesheet\">"
        text += "    <link href=\"${resource(dir: 'css/custom', file: 'texto.css')}\" rel=\"stylesheet\">"
        text += "    <link href=\"${resource(dir: 'css/custom', file: 'texto-vertical.css')}\" rel=\"stylesheet\">"

        out << text
    }

    def js = { attrs ->
        // jQuery (necessary for Bootstrap's JavaScript plugins)
        def text = " <script src=\"${resource(dir: 'js/jquery-ui-1.11.2/external/jquery', file: 'jquery.js')}\"></script>\n"
        text += "    <script src=\"${resource(dir: 'js/jquery-ui-1.11.2/', file: 'jquery-ui.min.js')}\"></script>\n"
        // Include all compiled plugins (below), or include individual files as needed
        text += "    <script src=\"${resource(dir: 'bootstrap-3.3.2/dist/js', file: 'bootstrap.min.js')}\"></script>\n"

        out << text
    }

    def customJs = { attrs ->
        def text = "    <script src=\"${resource(dir: 'js', file: 'funciones.js')}\"></script>"
        text += "    <script src=\"${resource(dir: 'js', file: 'functions.js')}\"></script>"
        text += "    <script src=\"${resource(dir: 'js', file: 'ui.js')}\"></script>"
        out << text
    }

    def validation = { attrs ->
        //context js
        def text = "    <script src=\"${resource(dir: 'js/plugins/jquery-validation-1.13.1/dist/', file: 'jquery.validate.min.js')}\"></script>"
        text += "    <script src=\"${resource(dir: 'js/plugins/jquery-validation-1.13.1/dist/localization', file: 'messages_es.min.js')}\"></script>"
        text += "    <script src=\"${resource(dir: 'js', file: 'jquery.validate.custom.tdn.js')}\"></script>"

        out << text
    }

    def plugins = { attrs ->
        //bootbox
        def text = " <script src=\"${resource(dir: 'js/plugins/bootbox-4.3.0/js', file: 'bootbox.js')}\"></script>\n"
        ///datepicker
        text += "    <script src=\"${resource(dir: 'js/plugins/moment-2.8.4.js', file: 'moment-with-locales.js')}\"></script>\n"
        text += "    <script src=\"${resource(dir: 'js/plugins/bootstrap-datetimepicker-3.1.3/build/js', file: 'bootstrap-datetimepicker.min.js')}\"></script>\n"
//        text += "    <script src=\"${resource(dir: 'js/plugins/bootstrap-datepicker/js/locales', file: 'bootstrap-datepicker.es.js')}\"></script>\n"
        text += "    <link href=\"${resource(dir: 'js/plugins/bootstrap-datetimepicker-3.1.3/build/css', file: 'bootstrap-datetimepicker.css')}\" rel=\"stylesheet\">"
        text += "    <link href=\"${resource(dir: 'css/custom/', file: 'datepicker.css')}\" rel=\"stylesheet\">"

//        text += "    <script src=\"${resource(dir: 'js/plugins/bootstrap-datepicker/js', file: 'bootstrap-datepicker.js')}\"></script>\n"
//        text += "    <script src=\"${resource(dir: 'js/plugins/bootstrap-datepicker/js/locales', file: 'bootstrap-datepicker.es.js')}\"></script>\n"
//        text += "    <link href=\"${resource(dir: 'js/plugins/bootstrap-datepicker/css', file: 'datepicker.css')}\" rel=\"stylesheet\">"
//        text += "    <link href=\"${resource(dir: 'css/custom/', file: 'datepicker.css')}\" rel=\"stylesheet\">"
        //maxlength
        text += "    <script src=\"${resource(dir: 'js/plugins/bootstrap-maxlength/js', file: 'bootstrap-maxlength.min.js')}\"></script>\n"
        //countdown
//        text += "    <script src=\"${resource(dir: 'js/plugins/jquery-countdown-2.0.1', file: 'jquery.countdown.js')}\"></script>"
//        text += "    <script src=\"${resource(dir: 'js/plugins/jquery-countdown-2.0.1', file: 'jquery.countdown-es.js')}\"></script>"
        //qtip2
        text += "    <script src=\"${resource(dir: 'js/plugins/jquery-qtip-2.2.1', file: 'jquery.qtip.min.js')}\"></script>"
        text += "    <link href=\"${resource(dir: 'js/plugins/jquery-qtip-2.2.1', file: 'jquery.qtip.min.css')}\" rel=\"stylesheet\">"
        //pines notify
        text += "    <script src=\"${resource(dir: 'js/plugins/jquery-pnotify-2.0', file: 'pnotify.custom.min.js')}\"></script>"
        text += "    <link href=\"${resource(dir: 'js/plugins/jquery-pnotify-2.0', file: 'pnotify.custom.min.css')}\" rel=\"stylesheet\">"
        //typeahead
        text += "    <script src=\"${resource(dir: 'js/plugins/jquery-typeahead-0.10.5', file: 'typeahead.js')}\"></script>"
        //context js
        text += "    <script type=\"text/javascript\" src=\"${resource(dir: 'js/plugins/lzm.context/js', file: 'lzm.context-0.5.js')}\"></script>"
        text += "    <link href=\"${resource(dir: 'js/plugins/lzm.context/css', file: 'lzm.context-0.5.css')}\" rel=\"stylesheet\">"
        //validation
        text += imp.validation()

        //tablas con headers fijos
//        text += "<script src=\"${resource(dir: 'js/plugins/fixed-header-table-1.3', file: 'jquery.fixedheadertable.js')}\"></script>"
//        text += "<link rel=\"stylesheet\" type=\"text/css\" href=\"${resource(dir: 'js/plugins/fixed-header-table-1.3/css', file: 'defaultTheme.css')}\"/>"
        //switches
        text += "<script src=\"${resource(dir: 'js/plugins/bootstrap-switch-3/dist/js', file: 'bootstrap-switch.js')}\"></script>"
        text += "<link rel=\"stylesheet\" type=\"text/css\" href=\"${resource(dir: 'js/plugins/bootstrap-switch-3/dist/css/bootstrap3', file: 'bootstrap-switch.css')}\"/>"

        //para el formato de los numeros en los inputs
        text += "<script type=\"text/javascript\" src=\"${resource(dir: 'js/plugins/jquery-inputmask-3.1.49/dist', file: 'jquery.inputmask.bundle.min.js')}\"></script>"
        out << text
    }

    def spinners = {
        def text = "<script type=\"text/javascript\">\n" +
                "            var spinner24Url = \"${resource(dir: 'images/spinners', file: 'spinner_24.GIF')}\";\n" +
                "            var spinner64Url = \"${resource(dir: 'images/spinners', file: 'spinner_64.GIF')}\";\n" +
                "\n" +
                "            var spinnerSquare64Url = \"${resource(dir: 'images/spinners', file: 'loading_new.GIF')}\";\n" +
                "\n" +
                "            var spinner = \$(\"<img src='\" + spinner24Url + \"' alt='Cargando...'/>\");\n" +
                "            var spinner64 = \$(\"<img src='\" + spinner64Url + \"' alt='Cargando...'/>\");\n" +
                "            var spinnerSquare64 = \$(\"<img src='\" + spinnerSquare64Url + \"' alt='Cargando...'/>\");\n" +
                "        </script>"
        out << text
    }
}
