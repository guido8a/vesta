<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/16/11
  Time: 11:35 AM
  To change this template use File | Settings | File Templates.
--%>

<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Modificaciones de proyecto</title>

        <script type="text/javascript" src="${resource(dir: 'js/jquery/plugins', file: 'jquery.hotkeys.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js/jquery/plugins', file: 'jquery.cookie.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js/jquery/plugins', file: 'jquery.jstree.js')}"></script>

        <style type="text/css">
        @page {
            size   : 29.7cm 21cm;  /*width height */
            margin : 2cm;
        }

        .hoja {
            width : 25.7cm;
        }

        .titulo {
            width : 25.7cm;
        }

        .hoja {
            /*background  : #e6e6fa;*/
            height      : 17cm; /*29.7-(1.5*2)*/
            font-family : arial;
            font-size   : 10pt;
        }

        .titulo {
            font-size     : 16pt;
            font-weight   : bold;
            text-align    : center;
            margin-bottom : .5cm;
            /*background    : #7fffd4;*/
        }
        </style>
    </head>

    <body>
        <div class="hoja">
            <div class="titulo">
                Modificaciones de proyecto
            </div>

            <g:each in="${mods}" var="mod" status="i">
                <fieldset>
                    <legend>Modificación: ${i + 1}</legend>
                    <table style="width: 95%;">
                        <thead>
                            <th style="width: 120px">Tipo</th>
                            <th>Original</th>
                            <th>Modificado</th>
                        </thead>
                        <tbody>
                            <g:set var="indis" value="${yachay.proyectos.Indicador.findAllByModificacion(mod,[sort:'id'])}"></g:set>
                            <g:set var="sups" value="${yachay.proyectos.Supuesto.findAllByModificacion(mod,[sort:'id'])}"></g:set>
                            <g:set var="medios"
                                   value="${yachay.proyectos.MedioVerificacion.findAllByModificacion(mod,[sort:'id'])}"></g:set>
                            <g:set var="mdcb"
                                   value="${yachay.proyectos.Modificables.findAllByModificacion(mod,[sort:'id'])}"></g:set>
                            <g:each in="${mdcb}" var="md">
                                <tr>
                                    <g:if test="${md.tipo==1}">
                                        <td><b>Fin</b></td>
                                        <g:set var="org" value="${yachay.proyectos.MarcoLogico.get(md.id_remoto.toLong())}"></g:set>
                                        <td>${org.objeto}</td>
                                        <td>${yachay.proyectos.MarcoLogico.findByPadreMod(org).objeto}</td>
                                    </g:if>
                                    <g:if test="${md.tipo==2}">
                                        <td><b>Proposito</b></td>
                                        <g:set var="org" value="${yachay.proyectos.MarcoLogico.get(md.id_remoto.toLong())}"></g:set>
                                        <td>${org.objeto}</td>
                                        <td>${yachay.proyectos.MarcoLogico.findByPadreMod(org).objeto}</td>
                                    </g:if>
                                    <g:if test="${md.tipo==3}">
                                        <td>Indicador</td>
                                        <g:set var="org" value="${yachay.proyectos.Indicador.get(md.id_remoto.toLong())}"></g:set>
                                        <td>${org.descripcion}</td>
                                        <g:if test="${indis.size()>0}">
                                            <td>${indis?.pop().descripcion}</td>
                                        </g:if>
                                    </g:if>
                                    <g:if test="${md.tipo==5}">
                                        <td>Supuesto</td>
                                        <g:set var="org" value="${yachay.proyectos.Supuesto.get(md.id_remoto.toLong())}"></g:set>
                                        <td>${org.descripcion}</td>
                                        <g:if test="${sups.size()>0}">
                                            <td>${sups?.pop().descripcion}</td>
                                        </g:if>
                                    </g:if>
                                    <g:if test="${md.tipo==6}">
                                        <td><b>Actividad</b></td>
                                        <g:set var="org" value="${yachay.proyectos.MarcoLogico.get(md.id_remoto.toLong())}"></g:set>
                                        <td>${org.objeto}</td>
                                        <td>${yachay.proyectos.MarcoLogico.findByPadreMod(org).objeto}</td>
                                    </g:if>
                                    <g:if test="${md.tipo==7}">
                                        <td>Med. Verificación.</td>
                                        <g:set var="org"
                                               value="${yachay.proyectos.MedioVerificacion.get(md.id_remoto.toLong())}"></g:set>
                                        <td>${org.descripcion}</td>
                                        <g:if test="${medios.size()>0}">
                                            <td>${medios?.pop().descripcion}</td>
                                        </g:if>
                                    </g:if>
                                    <g:if test="${md.tipo==8}">
                                        <td><b>Componente</b></td>
                                        <g:set var="org" value="${yachay.proyectos.MarcoLogico.get(md.id_remoto.toLong())}"></g:set>
                                        <td>${org.objeto}</td>
                                        <td>${yachay.proyectos.MarcoLogico.findByPadreMod(org).objeto}</td>
                                    </g:if>
                                </tr>
                            </g:each>
                        </tbody>
                    </table>
                </fieldset>
            </g:each>
        </div>
    </body>
</html>