(($) ->
    $.fn.flexibleCheckbox = (jsInit) ->

        drowBox = ($box) ->
            settings = $box.data 'flexibleCheckbox'
            $input = settings.target

            if $input.prop 'checked'
                $box
                    .fadeOut 50, () ->
                        $(@).removeClass settings.checkboxFalse
                        .addClass settings.checkboxTrue
                    .fadeIn 50
            else
                $box
                    .fadeOut 50, () ->
                        $(@).removeClass settings.checkboxTrue
                            .addClass settings.checkboxFalse
                    .fadeIn 50

            if not $input.find('+div').is $box
                $input.hide().after $box

        init = ($input) ->
            # default init
            settings =
                checkboxTrue: 'sprite-checkbox-true'
                checkboxFalse: 'sprite-checkbox-false'
                label: "[for=#{$input.attr('id')}]"
                drowBox: drowBox

            # HTML attr init
            forTemplate = []
            for key of settings
                attr = "data-#{key}"
                if typeof($input.attr attr) != 'undefined'
                    settings[key] = $input.attr attr

            # init from js
            $.extend settings, jsInit

            settings.target = $input
            label = $(settings.label)
            if label.size()
                label.removeAttr 'for'
                settings.label = label
            else
                settings.label = false
            settings.disabled = $input.prop 'disabled'
            settings

        clickHandler = () ->
            $box = $ @
            settings = $box.data 'flexibleCheckbox'
            $input = $ settings.target

            if $input.is('[type=radio]') and not $input.prop('checked')
                name = $input.attr('name')
                $form = $input.parents 'form'
                if $form.size()
                    $rel = $form.find "[name=#{name}]"
                else
                    $rel = $ "[name=#{name}]"
                $rel.each () ->
                    if $(@).prop 'checked'
                        $(@).prop 'checked', false
                        settings.drowBox $(@).find '+ div'

            if not $input.is('[type=radio]') or not $input.prop('checked')
                $input.prop 'checked', not $input.prop 'checked'
                $input.trigger 'change'
                settings.drowBox $box

        @.each () ->
            $input = $ @
            $box = $ '<div>'
            settings = init $input

            # stor data for future needs
            $box.data 'flexibleCheckbox', settings

            settings.drowBox($box)

            # bindings
            if not settings.disabled
                $box.click clickHandler
                if settings.label
                    settings.label.click clickHandler.bind $box[0]



    $ () ->
        $('.flexible-checkbox').flexibleCheckbox()

)(jQuery)
