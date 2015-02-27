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
    return this.optional(element) || value <= param;
}, jQuery.validator.format("Ingrese un valor inferior o igual a {0}."));

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
        var value2 = parseFloat($(params.params[0]).val());
        if (isNaN(value2)) {
            value2 = 0;
        }
        var max = parseFloat($(params.params[1]).data(params.params[2]));
        var total = value + value2;
        if (total <= max) {
            valid = true;
        }
    } catch (e) {
        //console.log(e);
    }
    //console.log("value ", value, "value2 ", value2, "max ", max, "total ", total, "valid?? ", valid);
    return this.optional(element) || valid;
}, jQuery.validator.format("Please enter the correct value for {0} + {1}"));
