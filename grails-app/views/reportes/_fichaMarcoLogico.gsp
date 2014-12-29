<div class="proyecto">
    <div class="subtitulo">
        ${it.proyecto?.nombre}
    </div>

    <div class="area">
        <div class="subtitulo2">
            FIN
        </div>

        <div class="area2">
            <div class="subtitulo3">
                Fin: ${it.fin.fin?.objeto}
            </div>

            <g:each in="${it.fin?.supuestos}" var="sup">
                <div class="subtitulo4">
                    Sup: ${sup}
                </div>
            </g:each>

            <g:each in="${it.fin?.indicadores}" var="ind">
                <div class="subtitulo4">
                    Ind: ${ind.indicador}
                    <g:each in="${ind.medios}" var="medio">
                        <div class="subtitulo5">
                            Medio: ${medio?.descripcion}
                        </div>
                    </g:each>
                </div>
            </g:each>
        </div>
    </div>

    <div class="area">
        <div class="subtitulo2">
            PROPÓSITO
        </div>

        <div class="area2">
            <div class="subtitulo3">
                Propósito: ${it.proposito.proposito?.objeto}
            </div>

            <g:each in="${it.proposito?.supuestos}" var="sup">
                <div class="subtitulo4">
                    Sup: ${sup}
                </div>
            </g:each>

            <g:each in="${it.proposito?.indicadores}" var="ind">
                <div class="subtitulo4">
                    Ind: ${ind.indicador}
                    <g:each in="${ind.medios}" var="medio">
                        <div class="subtitulo5">
                            Medio: ${medio?.descripcion}
                        </div>
                    </g:each>
                </div>
            </g:each>
        </div>
    </div>

</div>