local evo = {}

local function formatAttributeValue(attrName, attrValue)
    if type(attrValue) == "boolean" then
        return attrValue and "true" or "false"
    elseif type(attrValue) == "table" then
        return table.concat(attrValue, " ")
    elseif attrName == "type" or attrName == "src" or attrName == "href" then
        return tostring(attrValue)
    else
        return tostring(attrValue)
    end
end


function evo.createElement(tagName, attributes, content)
    local element = "<" .. tagName

    if attributes then
        for attrName, attrValue in pairs(attributes) do
            element = element .. " " .. attrName .. '="' .. formatAttributeValue(attrName, attrValue) .. '"'
        end
    end

    element = element .. ">"

    if content then
        element = element .. content
    end

    element = element .. "</" .. tagName .. ">"

    return element
end


local function createListItems(items)
    local children = {}
    for _, item in ipairs(items or {}) do
        table.insert(children, evo.createElement("li", nil, item))
    end
    return table.concat(children)
end

function evo.title(attributes, content)
    return evo.createElement("title", attributes, content)
end

local state = {}

function evo.setState(key, value)
    state[key] = value
end

function evo.getState(key)
    return state[key]
end

function evo.bindState(attributes, key)
    attributes = attributes or {}
    if state[key] then
        attributes.value = state[key]
        attributes.oninput = "evo.setState('" .. key .. "', this.value)"
    end
    return attributes
end


function evo.onInput(attributes, handler)
    return evo.addEventListener(attributes, "input", handler)
end


function evo.inputWithState(attributes, key)
    attributes = evo.bindState(attributes, key)
    return evo.createElement("input", attributes)
end

    local function hexToRgb(hex)
        hex = hex:gsub("#", "")
        return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
    end

function evo.addPlugin(plugin)
    if type(plugin) == "table" and type(plugin.init) == "function" then
        plugin.init(evo)
    else
        error("Invalid plugin format")
    end
end


function evo.h1(attributes, content) return evo.createElement("h1", attributes, content) end
function evo.h2(attributes, content) return evo.createElement("h2", attributes, content) end
function evo.main(attributes, content) return evo.createElement("main", attributes, content) end
function evo.body(attributes, content) return evo.createElement("body", attributes, content) end
function evo.html(attributes, content)
    return evo.createElement("html", attributes, content)
end
function evo.addClass(attributes, className)
    attributes = attributes or {}
    if attributes.class then
        attributes.class = attributes.class .. " " .. className
    else
        attributes.class = className
    end
    return attributes
end

function evo.div(attributes, content) return evo.createElement("div", attributes, content) end
function evo.mergeAttributes(...)
    local merged = {}
    for _, attrs in ipairs({...}) do
        for k, v in pairs(attrs) do
            merged[k] = v
        end
    end
    return merged
end

function evo.p(attributes, content) return evo.createElement("p", attributes, content) end
function evo.a(attributes, text, href) return evo.createElement("a", {href = href}, text) end
function evo.img(attributes) return evo.createElement("img", attributes) end
function evo.ul(attributes, items) return evo.createElement("ul", attributes, createListItems(items)) end
function evo.ol(attributes, items) return evo.createElement("ol", attributes, createListItems(items)) end
function evo.heading(level, attributes, content) return evo.createElement("h" .. level, attributes, content) end
function evo.span(attributes, content) return evo.createElement("span", attributes, content) end
function evo.table(attributes, rows)
    local tableContent = {}
    for _, row in ipairs(rows or {}) do
        local rowContent = {}
        for _, cell in ipairs(row) do
            table.insert(rowContent, evo.createElement("td", nil, cell))
        end
        table.insert(tableContent, evo.createElement("tr", nil, table.concat(rowContent)))
    end
    return evo.createElement("table", attributes, table.concat(tableContent))
end
function evo.form(attributes, content) return evo.createElement("form", attributes, content) end
function evo.input(attributes) return evo.createElement("input", attributes) end
function evo.textarea(attributes, content) return evo.createElement("textarea", attributes, content) end

function evo.checkContrast(color1, color2)
    local function luminance(r, g, b)
        local a = {r, g, b}
        for i, v in ipairs(a) do
            v = v / 255
            if v <= 0.03928 then
                v = v / 12.92
            else
                v = ((v + 0.055) / 1.055) ^ 2.4
            end
            a[i] = v
        end
        return a[1] * 0.2126 + a[2] * 0.7152 + a[3] * 0.0722
    end

    local function hexToRgb(hex)
        hex = hex:gsub("#", "")
        return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
    end

    local r1, g1, b1 = hexToRgb(color1)
    local r2, g2, b2 = hexToRgb(color2)
    local lum1 = luminance(r1, g1, b1)
    local lum2 = luminance(r2, g2, b2)
    local contrastRatio = (lum1 + 0.05) / (lum2 + 0.05)

    if lum2 > lum1 then
        contrastRatio = 1 / contrastRatio
    end

    return contrastRatio
end



function evo.onTouchStart(attributes, handler) return evo.addEventListener(attributes, "touchstart", handler) end
function evo.onTouchEnd(attributes, handler) return evo.addEventListener(attributes, "touchend", handler) end
function evo.onTouchMove(attributes, handler) return evo.addEventListener(attributes, "touchmove", handler) end
function evo.onTouchCancel(attributes, handler) return evo.addEventListener(attributes, "touchcancel", handler) end



function evo.button(attributes, content) return evo.createElement("button", attributes, content) end
function evo.label(attributes, content) return evo.createElement("label", attributes, content) end
function evo.select(attributes, options)
    local optionElements = {}
    for _, option in ipairs(options or {}) do
        local attrs = { value = option.value }
        if option.selected then attrs.selected = "selected" end
        table.insert(optionElements, evo.createElement("option", attrs, option.text))
    end
    return evo.createElement("select", attributes, table.concat(optionElements))
end
function evo.script(attributes, scriptContent) return evo.createElement("script", attributes, scriptContent) end
function evo.audio(attributes) return evo.createElement("audio", attributes) end
function evo.video(attributes) return evo.createElement("video", attributes) end
function evo.iframe(attributes) return evo.createElement("iframe", attributes) end
function evo.hr(attributes) return evo.createElement("hr", attributes) end
function evo.pre(attributes, content) return evo.createElement("pre", attributes, content) end
function evo.br() return "<br>" end
function evo.article(attributes, content) return evo.createElement("article", attributes, content) end
function evo.section(attributes, content) return evo.createElement("section", attributes, content) end
function evo.nav(attributes, content) return evo.createElement("nav", attributes, content) end
function evo.aside(attributes, content) return evo.createElement("aside", attributes, content) end
function evo.modal(attributes, content)
    return evo.createElement("div", evo.css(attributes, { display = "none", position = "fixed", top = "0", left = "0", width = "100%", height = "100%", ["background-color"] = "rgba(0, 0, 0, 0.5)" }), content)
end
function evo.head(attributes, content)
    return evo.createElement("head", attributes, content)
end

function evo.dropdown(attributes, items)
    local dropdownContent = evo.createElement("div", evo.css(nil, { display = "none", position = "absolute", ["background-color"] = "#f9f9f9", ["min-width"] = "160px", ["box-shadow"] = "0px 8px 16px 0px rgba(0,0,0,0.2)", ["z-index"] = "1" }), createListItems(items))
    return evo.createElement("div", attributes, dropdownContent)
end
function evo.applyTheme(theme)
    for element, styles in pairs(theme) do
        if evo[element] then
            local originalFunc = evo[element]
            evo[element] = function(attributes, content)
                attributes = evo.css(attributes, styles)
                return originalFunc(attributes, content)
            end
        end
    end
end
function evo.validateFormAdvanced(form, validationRules)
    local messages = {}
    for name, rules in pairs(validationRules) do
        local element = form.elements[name]
        if element then
            for rule, params in pairs(rules) do
                if rule == "required" and element.value == "" then
                    table.insert(messages, params.message)
                elseif rule == "minLength" and #element.value < params.value then
                    table.insert(messages, params.message)
                elseif rule == "maxLength" and #element.value > params.value then
                    table.insert(messages, params.message)
                elseif rule == "pattern" and not element.value:match(params.value) then
                    table.insert(messages, params.message)
                end
            end
        end
    end
    if #messages > 0 then
        return false, table.concat(messages, "\n")
    end
    return true
end
function evo.flexbox(attributes, flexProperties)
    return evo.css(attributes, flexProperties)
end

function evo.grid(attributes, gridProperties)
    return evo.css(attributes, gridProperties)
end

function evo.header(attributes, content) return evo.createElement("header", attributes, content) end
function evo.footer(attributes, content) return evo.createElement("footer", attributes, content) end
function evo.details(attributes, content) return evo.createElement("details", attributes, content) end
function evo.summary(attributes, content) return evo.createElement("summary", attributes, content) end


function evo.svg(attributes, content)
    return evo.createElement("svg", attributes, content)
end
function evo.circle(attributes) return evo.createElement("circle", attributes) end
function evo.rect(attributes) return evo.createElement("rect", attributes) end
function evo.line(attributes) return evo.createElement("line", attributes) end
function evo.polyline(attributes) return evo.createElement("polyline", attributes) end
function evo.polygon(attributes) return evo.createElement("polygon", attributes) end
function evo.ellipse(attributes) return evo.createElement("ellipse", attributes) end
function evo.path(attributes) return evo.createElement("path", attributes) end
function evo.text(attributes, content) return evo.createElement("text", attributes, content) end
function evo.defs(attributes, content) return evo.createElement("defs", attributes, content) end
function evo.g(attributes, content) return evo.createElement("g", attributes, content) end


function evo.math(attributes, content) return evo.createElement("math", attributes, content) end
function evo.mrow(attributes, content) return evo.createElement("mrow", attributes, content) end
function evo.msup(attributes, content) return evo.createElement("msup", attributes, content) end
function evo.msub(attributes, content) return evo.createElement("msub", attributes, content) end
function evo.mfrac(attributes, content) return evo.createElement("mfrac", attributes, content) end
function evo.msqrt(attributes, content) return evo.createElement("msqrt", attributes, content) end
function evo.mroot(attributes, content) return evo.createElement("mroot", attributes, content) end
function evo.mtable(attributes, content) return evo.createElement("mtable", attributes, content) end
function evo.mtr(attributes, content) return evo.createElement("mtr", attributes, content) end
function evo.mtd(attributes, content) return evo.createElement("mtd", attributes, content) end
function evo.mstyle(attributes, content) return evo.createElement("mstyle", attributes, content) end
function evo.mi(attributes, content) return evo.createElement("mi", attributes, content) end
function evo.mo(attributes, content) return evo.createElement("mo", attributes, content) end
function evo.mtext(attributes, content) return evo.createElement("mtext", attributes, content) end


function evo.addEventListener(attributes, event, handler)
    attributes = attributes or {}
    attributes["on" .. event] = handler
    return attributes
end

function evo.addMultipleEvents(attributes, events)
    attributes = attributes or {}
    for event, handler in pairs(events) do
        attributes["on" .. event] = handler
    end
    return attributes
end


function evo.onClick(attributes, handler) return evo.addEventListener(attributes, "click", handler) end
function evo.onChange(attributes, handler) return evo.addEventListener(attributes, "change", handler) end
function evo.onSubmit(attributes, handler) return evo.addEventListener(attributes, "submit", handler) end


function evo.css(attributes, styles)
    attributes = attributes or {}
    local styleString = ""
    for property, value in pairs(styles) do
        styleString = styleString .. property .. ":" .. value .. ";"
    end
    attributes.style = styleString
    return attributes
end

function evo.padding(attributes, padding) return evo.css(attributes, { padding = padding }) end
function evo.margin(attributes, margin) return evo.css(attributes, { margin = margin }) end
function evo.meta(attributes)
    return evo.createElement("meta", attributes)
end
function evo.width(attributes, width) return evo.css(attributes, { width = width }) end
function evo.height(attributes, height) return evo.css(attributes, { height = height }) end
function evo.background(attributes, color) return evo.css(attributes, { ["background-color"] = color }) end
function evo.color(attributes, color) return evo.css(attributes, { color = color }) end
function evo.fontSize(attributes, size) return evo.css(attributes, { ["font-size"] = size }) end
function evo.border(attributes, border) return evo.css(attributes, { border = border }) end
function evo.display(attributes, display) return evo.css(attributes, { display = display }) end
function evo.flex(attributes) return evo.css(attributes, { display = "flex" }) end

function evo.gridTemplateColumns(attributes, columns) return evo.css(attributes, { ["grid-template-columns"] = columns }) end
function evo.gridTemplateRows(attributes, rows) return evo.css(attributes, { ["grid-template-rows"] = rows }) end
function evo.style(attributes, cssContent)
    return evo.createElement("style", attributes, cssContent)
end
function evo.gridArea(attributes, area) return evo.css(attributes, { ["grid-area"] = area }) end
function evo.animate(attributes, animation) return evo.css(attributes, { animation = animation }) end
function evo.opacity(attributes, opacity) return evo.css(attributes, { opacity = opacity }) end
function evo.boxShadow(attributes, shadow) return evo.css(attributes, { ["box-shadow"] = shadow }) end
function evo.textAlign(attributes, align) return evo.css(attributes, { ["text-align"] = align }) end
function evo.fontWeight(attributes, weight) return evo.css(attributes, { ["font-weight"] = weight }) end
function evo.lineHeight(attributes, height) return evo.css(attributes, { ["line-height"] = height }) end
function evo.textTransform(attributes, transform) return evo.css(attributes, { ["text-transform"] = transform }) end
function evo.cursor(attributes, cursor) return evo.css(attributes, { cursor = cursor }) end
function evo.zIndex(attributes, index) return evo.css(attributes, { ["z-index"] = index }) end


function evo.serializeForm(form)
    local result = {}
    for i = 1, #form.elements do
        local element = form.elements[i]
        if element.name then
            if element.type == "checkbox" or element.type == "radio" then
                if element.checked then
                    result[element.name] = element.value
                end
            else
                result[element.name] = element.value
            end
        end
    end
    return result
end

function evo.validateForm(form, validationRules)
    local messages = {}
    for name, rules in pairs(validationRules) do
        local element = form.elements[name]
        if element then
            for rule, message in pairs(rules) do
                if rule == "required" and element.value == "" then
                    table.insert(messages, message)
                end
                if rule == "minLength" and #element.value < (rules.minLength or 0) then
                    table.insert(messages, message)
                end
                if rule == "maxLength" and #element.value > (rules.maxLength or 0) then
                    table.insert(messages, message)
                end
                if rule == "pattern" and not element.value:match(rules.pattern) then
                    table.insert(messages, message)
                end
            end
        end
    end
    if #messages > 0 then
        return false, table.concat(messages, "\n")
    end
    return true
end
function evo.handleFormSubmit(form, validationRules, submitHandler)
    local isValid, message = evo.validateForm(form, validationRules)
    if isValid then
        submitHandler(evo.serializeForm(form))
    else
        print(message) 
    end
end



function evo.customElement(name, func)
    if type(name) == "string" and type(func) == "function" then
        evo[name] = func
    else
        error("Invalid arguments for customElement")
    end
end

evo.customElement("customCard", function(attributes, title, content)
    return evo.div(attributes, evo.heading(3, nil, title) .. evo.p(nil, content))
end)


function evo.d3script()
    return evo.createElement("script", { src = "https://d3js.org/d3.v6.min.js" })
end

function evo.createChart(attributes, data)
    local script = [[
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        var svg = d3.select(']] .. attributes.selector .. [[')
        .append('svg')
        .attr('width', 500)
        .attr('height', 500);
        // Example chart creation logic here
    });
    </script>
    ]]
    return evo.script(nil, script)
end


function evo.template(templateString, data)
    return (templateString:gsub("{{(.-)}}", function(w)
        return data[w:match("%S+")] or w
    end))
end




function evo.progress(attributes, value, max)
    attributes = attributes or {}
    attributes.value = value
    attributes.max = max
    return evo.createElement("progress", attributes)
end

function evo.range(attributes, value, min, max)
    attributes = attributes or {}
    attributes.type = "range"
    attributes.value = value
    attributes.min = min
    attributes.max = max
    return evo.createElement("input", attributes)
end


function evo.aria(attributes, ariaAttributes)
    attributes = attributes or {}
    for ariaAttr, value in pairs(ariaAttributes) do
        attributes["aria-" .. ariaAttr] = value
    end
    return attributes
end


function evo.generateList(items, ordered, attributes)
    if ordered then
        return evo.ol(attributes, items)
    else
        return evo.ul(attributes, items)
    end
end
function evo.createCustomElement(tagName, attributes, content)
  
    return evo.createElement(tagName, attributes, content)
end
return evo
message.txt
20 KB
