<%@ page import="vesta.parametros.proyectos.GrupoProcesos" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>

<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <a href="#" class="btn btn-sm btn-success btnAdd">
            <i class="fa fa-plus"></i> Agregar
        </a>
    </div>

    <div class="btn-group">
        <a class="btn btn-sm btn-danger">
            <i class="fa fa-trash-o"></i> Eliminar
        </a>
    </div>

    <div class="btn-group">
        <div class="input-group input-group-sm col-md-3">
            <input type="text" class="form-control" placeholder="Buscar">
            <span class="input-group-btn">
                <button class="btn btn-default" type="button" id="btnSearch"><i class="fa fa-search"></i></button>
            </span>
        </div><!-- /input-group -->
    </div>
</div>