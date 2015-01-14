<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <title><g:layoutTitle default="Vesta"/></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <imp:favicon/>
    <imp:js/>
    <imp:plugins/>
    <imp:customJs/>

    <imp:spinners/>

    <imp:css/>

    <g:layoutHead/>
    <script type="text/javascript">
    var index = 1041;
    function bringToTop(element){
//        console.log("btt",element)
        element.css({"zIndex":index})
        index++;
    }
    function bringToTopCustom(element,zIndex){
//        console.log("btt2",element,zIndex)
        element.css({"zIndex":zIndex})
    }
    </script>
    <style type="text/css">
            i{
                margin-right: 5px;

            }
    </style>
</head>

<body>
<mn:bannerTop/>

<mn:menu title="${g.layoutTitle(default: 'Vesta')}"/>

<div class="container" id="mass-container">
    <g:layoutBody/>
</div>

<mn:stickyFooter2/>
<mn:stickyFooter/>
</body>
</html>
