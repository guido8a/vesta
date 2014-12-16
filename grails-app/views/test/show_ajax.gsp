
<%@ page import="vesta.test.Test" %>

<g:if test="${!testInstance}">
    <elm:notFound elem="Test" genero="o" />
</g:if>
<g:else>

    <g:if test="${testInstance?.codigo}">
        <div class="row">
            <div class="col-md-2">
                Codigo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${testInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${testInstance?.email}">
        <div class="row">
            <div class="col-md-2">
                Email
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${testInstance}" field="email"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${testInstance?.existe}">
        <div class="row">
            <div class="col-md-2">
                Existe
            </div>
            
            <div class="col-md-3">
                <g:formatBoolean boolean="${testInstance?.existe}" true="Sí" false="No" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${testInstance?.fecha}">
        <div class="row">
            <div class="col-md-2">
                Fecha
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${testInstance?.fecha}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${testInstance?.fechaHora}">
        <div class="row">
            <div class="col-md-2">
                Fecha Hora
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${testInstance?.fechaHora}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${testInstance?.login}">
        <div class="row">
            <div class="col-md-2">
                Login
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${testInstance}" field="login"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${testInstance?.mail}">
        <div class="row">
            <div class="col-md-2">
                Mail
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${testInstance}" field="mail"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${testInstance?.nombre}">
        <div class="row">
            <div class="col-md-2">
                Nombre
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${testInstance}" field="nombre"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${testInstance?.numeroDecimal}">
        <div class="row">
            <div class="col-md-2">
                Numero Decimal
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${testInstance}" field="numeroDecimal"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${testInstance?.numeroEntero}">
        <div class="row">
            <div class="col-md-2">
                Numero Entero
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${testInstance}" field="numeroEntero"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${testInstance?.password}">
        <div class="row">
            <div class="col-md-2">
                Password
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${testInstance}" field="password"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>