<%@ page import="vesta.proyectos.Proyecto" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!proyectoInstance}">
    <elm:notFound elem="Proyecto" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmProyecto" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${proyectoInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'unidadEjecutora', 'error')} ">
            <span class="grupo">
                <label for="unidadEjecutora" class="col-md-2 control-label">
                    Unidad Ejecutora
                </label>
                <div class="col-md-7">
                    <g:select id="unidadEjecutora" name="unidadEjecutora.id" from="${vesta.parametros.UnidadEjecutora.list()}" optionKey="id" value="${proyectoInstance?.unidadEjecutora?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'etapa', 'error')} ">
            <span class="grupo">
                <label for="etapa" class="col-md-2 control-label">
                    Etapa
                </label>
                <div class="col-md-7">
                    <g:select id="etapa" name="etapa.id" from="${vesta.parametros.Etapa.list()}" optionKey="id" value="${proyectoInstance?.etapa?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'fase', 'error')} ">
            <span class="grupo">
                <label for="fase" class="col-md-2 control-label">
                    Fase
                </label>
                <div class="col-md-7">
                    <g:select id="fase" name="fase.id" from="${vesta.parametros.Fase.list()}" optionKey="id" value="${proyectoInstance?.fase?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'tipoProducto', 'error')} ">
            <span class="grupo">
                <label for="tipoProducto" class="col-md-2 control-label">
                    Tipo Producto
                </label>
                <div class="col-md-7">
                    <g:select id="tipoProducto" name="tipoProducto.id" from="${vesta.parametros.TipoProducto.list()}" optionKey="id" value="${proyectoInstance?.tipoProducto?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'estadoProyecto', 'error')} ">
            <span class="grupo">
                <label for="estadoProyecto" class="col-md-2 control-label">
                    Estado Proyecto
                </label>
                <div class="col-md-7">
                    <g:select id="estadoProyecto" name="estadoProyecto.id" from="${vesta.parametros.EstadoProyecto.list()}" optionKey="id" value="${proyectoInstance?.estadoProyecto?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'linea', 'error')} ">
            <span class="grupo">
                <label for="linea" class="col-md-2 control-label">
                    Linea
                </label>
                <div class="col-md-7">
                    <g:select id="linea" name="linea.id" from="${vesta.parametros.Linea.list()}" optionKey="id" value="${proyectoInstance?.linea?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'tipoInversion', 'error')} ">
            <span class="grupo">
                <label for="tipoInversion" class="col-md-2 control-label">
                    Tipo Inversion
                </label>
                <div class="col-md-7">
                    <g:select id="tipoInversion" name="tipoInversion.id" from="${vesta.parametros.TipoInversion.list()}" optionKey="id" value="${proyectoInstance?.tipoInversion?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'cobertura', 'error')} ">
            <span class="grupo">
                <label for="cobertura" class="col-md-2 control-label">
                    Cobertura
                </label>
                <div class="col-md-7">
                    <g:select id="cobertura" name="cobertura.id" from="${vesta.parametros.Cobertura.list()}" optionKey="id" value="${proyectoInstance?.cobertura?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'calificacion', 'error')} ">
            <span class="grupo">
                <label for="calificacion" class="col-md-2 control-label">
                    Calificacion
                </label>
                <div class="col-md-7">
                    <g:select id="calificacion" name="calificacion.id" from="${vesta.parametros.Calificacion.list()}" optionKey="id" value="${proyectoInstance?.calificacion?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'programa', 'error')} ">
            <span class="grupo">
                <label for="programa" class="col-md-2 control-label">
                    Programa
                </label>
                <div class="col-md-7">
                    <g:select id="programa" name="programa.id" from="${vesta.parametros.proyectos.Programa.list()}" optionKey="id" value="${proyectoInstance?.programa?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'codigoProyecto', 'error')} ">
            <span class="grupo">
                <label for="codigoProyecto" class="col-md-2 control-label">
                    Codigo Proyecto
                </label>
                <div class="col-md-7">
                    <g:textField name="codigoProyecto" maxlength="24" class="form-control unique noEspacios" value="${proyectoInstance?.codigoProyecto}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'fechaRegistro', 'error')} ">
            <span class="grupo">
                <label for="fechaRegistro" class="col-md-2 control-label">
                    Fecha Registro
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaRegistro" mensaje="Fecha de Registro en la SENPLADES"  class="datepicker form-control" value="${proyectoInstance?.fechaRegistro}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'fechaModificacion', 'error')} ">
            <span class="grupo">
                <label for="fechaModificacion" class="col-md-2 control-label">
                    Fecha Modificacion
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaModificacion" mensaje="Fecha de Modificación del proyecto"  class="datepicker form-control" value="${proyectoInstance?.fechaModificacion}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'nombre', 'error')} required">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label">
                    Nombre
                </label>
                <div class="col-md-7">
                    <g:textArea name="nombre" cols="40" rows="5" maxlength="255" required="" class="form-control required" value="${proyectoInstance?.nombre}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'monto', 'error')} ">
            <span class="grupo">
                <label for="monto" class="col-md-2 control-label">
                    Monto
                </label>
                <div class="col-md-3">
                    <g:field name="monto" type="number" value="${fieldValue(bean: proyectoInstance, field: 'monto')}" class="number form-control "/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'producto', 'error')} ">
            <span class="grupo">
                <label for="producto" class="col-md-2 control-label">
                    Producto
                </label>
                <div class="col-md-7">
                    <g:textArea name="producto" cols="40" rows="5" maxlength="1023" class="form-control" value="${proyectoInstance?.producto}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label">
                    Descripcion
                </label>
                <div class="col-md-7">
                    <g:textArea name="descripcion" cols="40" rows="5" maxlength="1024" class="form-control" value="${proyectoInstance?.descripcion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'fechaInicioPlanificada', 'error')} ">
            <span class="grupo">
                <label for="fechaInicioPlanificada" class="col-md-2 control-label">
                    Fecha Inicio Planificada
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaInicioPlanificada" mensaje="Fecha de inicio según el plan o programada"  class="datepicker form-control" value="${proyectoInstance?.fechaInicioPlanificada}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'fechaInicio', 'error')} ">
            <span class="grupo">
                <label for="fechaInicio" class="col-md-2 control-label">
                    Fecha Inicio
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaInicio" mensaje="Fecha de Inicio real"  class="datepicker form-control" value="${proyectoInstance?.fechaInicio}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'fechaFinPlanificada', 'error')} ">
            <span class="grupo">
                <label for="fechaFinPlanificada" class="col-md-2 control-label">
                    Fecha Fin Planificada
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaFinPlanificada" mensaje="Fecha de finalización según el plan o programada"  class="datepicker form-control" value="${proyectoInstance?.fechaFinPlanificada}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'fechaFin', 'error')} ">
            <span class="grupo">
                <label for="fechaFin" class="col-md-2 control-label">
                    Fecha Fin
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaFin" mensaje="Fecha de finalización real"  class="datepicker form-control" value="${proyectoInstance?.fechaFin}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'mes', 'error')} ">
            <span class="grupo">
                <label for="mes" class="col-md-2 control-label">
                    Mes
                </label>
                <div class="col-md-3">
                    <g:field name="mes" type="number" value="${proyectoInstance.mes}" class="digits form-control"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'problema', 'error')} ">
            <span class="grupo">
                <label for="problema" class="col-md-2 control-label">
                    Problema
                </label>
                <div class="col-md-7">
                    <g:textArea name="problema" cols="40" rows="5" maxlength="1024" class="form-control" value="${proyectoInstance?.problema}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'informacionDias', 'error')} ">
            <span class="grupo">
                <label for="informacionDias" class="col-md-2 control-label">
                    Informacion Dias
                </label>
                <div class="col-md-3">
                    <g:field name="informacionDias" type="number" value="${proyectoInstance.informacionDias}" class="digits form-control"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'subPrograma', 'error')} ">
            <span class="grupo">
                <label for="subPrograma" class="col-md-2 control-label">
                    Sub Programa
                </label>
                <div class="col-md-7">
                    <g:textField name="subPrograma" maxlength="2" class="form-control" value="${proyectoInstance?.subPrograma}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'aprobado', 'error')} ">
            <span class="grupo">
                <label for="aprobado" class="col-md-2 control-label">
                    Aprobado
                </label>
                <div class="col-md-7">
                    <g:textField name="aprobado" maxlength="1" class="form-control" value="${proyectoInstance?.aprobado}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'aprobadoPoa', 'error')} ">
            <span class="grupo">
                <label for="aprobadoPoa" class="col-md-2 control-label">
                    Aprobado Poa
                </label>
                <div class="col-md-7">
                    <g:textField name="aprobadoPoa" maxlength="1" class="form-control" value="${proyectoInstance?.aprobadoPoa}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'objetivoEstrategico', 'error')} ">
            <span class="grupo">
                <label for="objetivoEstrategico" class="col-md-2 control-label">
                    Objetivo Estrategico
                </label>
                <div class="col-md-7">
                    <g:select id="objetivoEstrategico" name="objetivoEstrategico.id" from="${vesta.proyectos.ObjetivoEstrategicoProyecto.list()}" optionKey="id" value="${proyectoInstance?.objetivoEstrategico?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'ejeProgramatico', 'error')} ">
            <span class="grupo">
                <label for="ejeProgramatico" class="col-md-2 control-label">
                    Eje Programatico
                </label>
                <div class="col-md-7">
                    <g:select id="ejeProgramatico" name="ejeProgramatico.id" from="${vesta.proyectos.EjeProgramatico.list()}" optionKey="id" value="${proyectoInstance?.ejeProgramatico?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'lineaBase', 'error')} ">
            <span class="grupo">
                <label for="lineaBase" class="col-md-2 control-label">
                    Linea Base
                </label>
                <div class="col-md-7">
                    <g:textArea name="lineaBase" cols="40" rows="5" maxlength="1023" class="form-control" value="${proyectoInstance?.lineaBase}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'poblacionObjetivo', 'error')} ">
            <span class="grupo">
                <label for="poblacionObjetivo" class="col-md-2 control-label">
                    Poblacion Objetivo
                </label>
                <div class="col-md-7">
                    <g:textArea name="poblacionObjetivo" cols="40" rows="5" maxlength="1023" class="form-control" value="${proyectoInstance?.poblacionObjetivo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'objetivoGobiernoResultado', 'error')} ">
            <span class="grupo">
                <label for="objetivoGobiernoResultado" class="col-md-2 control-label">
                    Objetivo Gobierno Resultado
                </label>
                <div class="col-md-7">
                    <g:select id="objetivoGobiernoResultado" name="objetivoGobiernoResultado.id" from="${vesta.parametros.proyectos.ObjetivoGobiernoResultado.list()}" optionKey="id" value="${proyectoInstance?.objetivoGobiernoResultado?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'programaPresupuestario', 'error')} ">
            <span class="grupo">
                <label for="programaPresupuestario" class="col-md-2 control-label">
                    Programa Presupuestario
                </label>
                <div class="col-md-7">
                    <g:select id="programaPresupuestario" name="programaPresupuestario.id" from="${vesta.parametros.poaPac.ProgramaPresupuestario.list()}" optionKey="id" value="${proyectoInstance?.programaPresupuestario?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'codigoEsigef', 'error')} ">
            <span class="grupo">
                <label for="codigoEsigef" class="col-md-2 control-label">
                    Codigo Esigef
                </label>
                <div class="col-md-7">
                    <g:textField name="codigoEsigef" maxlength="3" class="form-control unique noEspacios" value="${proyectoInstance?.codigoEsigef}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'unidadAdministradora', 'error')} ">
            <span class="grupo">
                <label for="unidadAdministradora" class="col-md-2 control-label">
                    Unidad Administradora
                </label>
                <div class="col-md-7">
                    <g:select id="unidadAdministradora" name="unidadAdministradora.id" from="${vesta.parametros.UnidadEjecutora.list()}" optionKey="id" value="${proyectoInstance?.unidadAdministradora?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'portafolio', 'error')} ">
            <span class="grupo">
                <label for="portafolio" class="col-md-2 control-label">
                    Portafolio
                </label>
                <div class="col-md-7">
                    <g:select id="portafolio" name="portafolio.id" from="${vesta.proyectos.Portafolio.list()}" optionKey="id" value="${proyectoInstance?.portafolio?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label">
                    Codigo
                </label>
                <div class="col-md-7">
                    <g:textField name="codigo" class="form-control unique noEspacios" value="${proyectoInstance?.codigo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'estrategia', 'error')} ">
            <span class="grupo">
                <label for="estrategia" class="col-md-2 control-label">
                    Estrategia
                </label>
                <div class="col-md-7">
                    <g:select id="estrategia" name="estrategia.id" from="${vesta.proyectos.Estrategia.list()}" optionKey="id" value="${proyectoInstance?.estrategia?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmProyecto").validate({
            errorClass     : "help-block",
            errorPlacement : function (error, element) {
                if (element.parent().hasClass("input-group")) {
                    error.insertAfter(element.parent());
                } else {
                    error.insertAfter(element);
                }
                element.parents(".grupo").addClass('has-error');
            },
            success        : function (label) {
                label.parents(".grupo").removeClass('has-error');
            }
            
            , rules          : {
                
                codigoProyecto: {
                    remote: {
                        url: "${createLink(action: 'validar_unique_codigoProyecto_ajax')}",
                        type: "post",
                        data: {
                            id: "${proyectoInstance?.id}"
                        }
                    }
                },
                
                codigoEsigef: {
                    remote: {
                        url: "${createLink(action: 'validar_unique_codigoEsigef_ajax')}",
                        type: "post",
                        data: {
                            id: "${proyectoInstance?.id}"
                        }
                    }
                },
                
                codigo: {
                    remote: {
                        url: "${createLink(action: 'validar_unique_codigo_ajax')}",
                        type: "post",
                        data: {
                            id: "${proyectoInstance?.id}"
                        }
                    }
                }
                
            },
            messages : {
                
                codigoProyecto: {
                    remote: "Ya existe Codigo Proyecto"
                },
                
                codigoEsigef: {
                    remote: "Ya existe Codigo Esigef"
                },
                
                codigo: {
                    remote: "Ya existe Codigo"
                }
                
            }
            
        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitForm();
                return false;
            }
            return true;
        });
    </script>

</g:else>