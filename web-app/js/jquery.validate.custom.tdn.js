/**
 * Created by luz on 31/12/14.
 */
jQuery.validator.addMethod("notEqualTo", function (value, element, param) {
    // bind to the blur event of the target in order to revalidate whenever the target field is updated
    // TODO find a way to bind the event just once, avoiding the unbind-rebind overhead
    var target = $(param);
    if (this.settings.onfocusout) {
        target.unbind(".validate-notEqualTo").bind("blur.validate-notEqualTo", function () {
            $(element).valid();
        });
    }
    return value !== target.val();
}, jQuery.validator.format("No ingrese ese valor."));

jQuery.validator.addMethod("tdnMax", function (value, element, param) {
    value = parseFloat(str_replace(",", "", value));
    param = parseFloat(param);
    param = Math.round(param * 100) / 100;
    //var sum = param + value;
    //console.log("tdnMax", "elem ", element, "val ", value, 'param ', param, 'optional ', this.optional(element), 'boolean ', value < param);
    return this.optional(element) || value <= param;
}, jQuery.validator.format("Ingrese un valor inferior o igual a {0}."));

jQuery.validator.addMethod("requiredCombo", function (value, element) {
    return value.toString() != "-1";
}, jQuery.validator.format("Por favor seleccione una opción"));

jQuery.validator.addMethod("uniqueTableBody", function (value, element, params) {
    var $tableBody = $(params[0]);
    var data = params[1];
    var ok = true;
    $tableBody.children("tr").each(function () {
        if ("" + $(this).data(data) == "" + value) {
            ok = false;
        }
    });
    return ok;
}, jQuery.validator.format("Por favor seleccione otra asignación"));

/**
 * verifica que la suma de 2 fields no supere el data de un elemento
 * params[0] : el id del 2do field
 * params[1] : el id del div
 * params[2] : el nombre del data donde se almacena el valor
 */
jQuery.validator.addMethod("tdnMaxSuma", function (value, element, params) {
    var valid = false;
    value = parseFloat(str_replace(",", "", value));
    try {
        var value2 = str_replace(",", "", $(params.params[0]).val());
        value2 = parseFloat(value2);
        if (isNaN(value2)) {
            value2 = 0;
        }
        var max = parseFloat($(params.params[1]).data(params.params[2]));
        max += parseFloat($(params.params[1]).data(params.params[3]));
        max = Math.round(max * 100) / 100;
        var total = value + value2;
        total = Math.round(total * 100) / 100;
        if (total <= max) {
            valid = true;
        }
    } catch (e) {
        //console.log(e);
    }
    return this.optional(element) || valid;
}, jQuery.validator.format("Please enter the correct value for {0} + {1}"));
