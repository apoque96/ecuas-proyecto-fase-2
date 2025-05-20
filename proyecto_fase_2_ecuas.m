%% 
function outerFunction()
    application = 0;


    % Initialize layout
    fig = uifigure("Name", "Simulador de aplicaciones de Ecuaciones Diferenciales", ...
        "Color", "#ffffff", ...
        "AutoResizeChildren", "off");
    
    % Left panel
    leftPanel = uipanel(fig, "BackgroundColor", "#f0f1ff", ...
        "Position", [0, 0, 0, 0], ... 
        "BorderColor", "#ffffff");
    
    % Initialize the radio buttons
    bg = uibuttongroup(leftPanel, "BackgroundColor", "#f0f1ff", ...
        "BorderColor", "#f0f1ff", ...
        "Position", [10, 0, 250, 120], ...
    "SelectionChangedFcn", @(bg, event) onSelectionChanged(event));

    % Define the callback function
    function onSelectionChanged(event)
        selected = event.NewValue.Text;
        switch selected
            case "Resortes: Movimiento libre no amortiguado"
                application = 0;
            case "Resortes: Movimiento libre amortiguado"
                application = 1;
            case "Resortes: Movimiento forzado"
                application = 2;
            case "Circuito en serie análogo: carga"
                application = 3;
            case "Circuito en serie análogo: corriente"
                application = 4;
        end
        positions();
    end

    btnUndamped = uiradiobutton(bg, "Value", 1, ...
        "Text", "Resortes: Movimiento libre no amortiguado", ...
        "Position", [0, 88, 250, 20]);
    
    btnDamped = uiradiobutton(bg, "Value", 0, ...
        "Text", "Resortes: Movimiento libre amortiguado", ...
        "Position", [0, 66, 250, 20]);
    
    btnForzed = uiradiobutton(bg, "Value", 0, ...
        "Text", "Resortes: Movimiento forzado", ...
        "Position", [0, 44, 250, 20]);
    
    btnCircuitCharge = uiradiobutton(bg, "Value", 0, ...
        "Text", "Circuito en serie análogo: carga", ...
        "Position", [0, 22, 250, 20]);

    btnCircuitCurrent = uiradiobutton(bg, "Value", 0, ...
        "Text", "Circuito en serie análogo: corriente", ...
        "Position", [0, 0, 250, 20]);
    
    % Right panel
    rightPanel = uipanel(fig, "BackgroundColor", "#ffffff", ...
    "Position", [0, 0, 0, 0], ... 
    "BorderColor", "#ffffff", ...
    "Scrollable", "on");

    ax = uiaxes(rightPanel, "XLim", [0 10]);
    ax.XLabel.String = 't (s)';
    ax.YLabel.String = 'x (ft)';
    ax.Title.String = 'Resortes: Movimiento libre no amortiguado';
    ax.Position = [10, 10, 400, 300];

    
    % Create labels and edit fields for all variables
    % W (Peso)
    weightLabel = uilabel(rightPanel, "Text", "W (Peso)");
    
    weight = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.2f lbs", ...
        "Value", 24, ...
        "ValueChangedFcn", @(src, event) plotFunction());
    
    % K (Constante del resorte)
    kLabel = uilabel(rightPanel, "Text", "K (Constante del resorte)");
    
    kValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.2f lb/ft", ...
        "Value", 72, ...
        "ValueChangedFcn", @(src, event) plotFunction());
    
    % ω² (omega cuadrado)
    wSquaredLabel = uilabel(rightPanel, "Text", "ω² (omega cuadrado)");
    
    wSquaredValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.4f", ...
        "Value", 96, ...
        "Editable", "on", ...
        "ValueChangedFcn", @(src, event) plotFunction());

    
    % w (omega)
    wLabel = uilabel(rightPanel, "Text", "ω (omega)");
    
    wValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.4f", ...
        "Value", 9.7980, ...
        "Editable", "on", ...
        "ValueChangedFcn", @(src, event) plotFunction());
    % m (Masa)
    massLabel = uilabel(rightPanel, "Text", "m (Masa)");
    
    massValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.2f slugs", ...
        "Value", 0.75, ...
        "ValueChangedFcn", @(src, event) plotFunction());

    % β
    betaLabel = uilabel(rightPanel, "Text", "β");
    
    betaValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.2f", ...
        "Value", 0.5, ...
        "ValueChangedFcn", @(src, event) plotFunction());

    % F0 (Fuerza externa)
    F0Label = uilabel(rightPanel, "Text", "F(t)"); % ←¡Crear como uilabel!
    F0Label.Text = "F(t)";
    F0Value = uieditfield(rightPanel, "text", ...
        "Value", "10*cos(5*t)", ... 
        "ValueChangedFcn", @(src, event) plotFunction());

    % 2λ
    lambdaLabel = uilabel(rightPanel, "Text", "2λ");
    
    lambdaValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.2f", ...
        "Value", 0.5, ...
        "ValueChangedFcn", @(src, event) plotFunction());

    % x (Alargamiento)
    xLabel = uilabel(rightPanel, "Text", "x (Alargamiento)");
    
    xValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [-1000000000 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.2f ft", ...
        "Value", 1/3, ...
        "ValueChangedFcn", @(src, event) plotFunction());
    
    % t (tiempo)
    tLabel = uilabel(rightPanel, "Text", "t (tiempo)");
    
    tValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.2f s", ...
        "Value", 0, ...
        "ValueChangedFcn", @(src, event) plotFunction());
    
    % t1 (tiempo)
    t1Label = uilabel(rightPanel, "Text", "t1 (tiempo)");
    
    t1Value = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.2f s", ...
        "Value", 0, ...
        "ValueChangedFcn", @(src, event) plotFunction());
    
    % t2 (tiempo)
    t2Label = uilabel(rightPanel, "Text", "t2 (tiempo)");
    
    t2Value = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.2f s", ...
        "Value", 5, ...
        "ValueChangedFcn", @(src, event) plotFunction());
    
    % x(t1) (Distancia)
    xt1Label = uilabel(rightPanel, "Text", "x(t1) (Distancia)");
    
    xt1Value = uieditfield(rightPanel, "numeric", ...
        "Limits", [-1000000000 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.2f ft", ...
        "Value", -0.25, ...
        "ValueChangedFcn", @(src, event) plotFunction()); 
    
    % x'(t2) (Distancia)
    xt2Label = uilabel(rightPanel, "Text", "x'(t2) (Distancia)");
    
    xt2Value = uieditfield(rightPanel, "numeric", ...
        "Limits", [-1000000000 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.2f ft", ...
        "Value", 0, ...
        "ValueChangedFcn", @(src, event) plotFunction()); 

    % L (Inductancia)
    lLabel = uilabel(rightPanel, "Text", "L (Inductancia)");
    
    lValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "off", ...
        "ValueDisplayFormat", "%.2f H", ...
        "Value", 1, ...
        "ValueChangedFcn", @(src, event) plotFunction()); 

    % R (Resistencia)
    rLabel = uilabel(rightPanel, "Text", "R (Resistencia)");
    
    rValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "off", ...
        "ValueDisplayFormat", "%.2f Ω", ...
        "Value", 2, ...
        "ValueChangedFcn", @(src, event) plotFunction()); 

    % C (Capacitancia)
    cLabel = uilabel(rightPanel, "Text", "C (Capacitancia)");
    
    cValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "off", ...
        "ValueDisplayFormat", "%.2f F", ...
        "Value", 0.25, ...
        "ValueChangedFcn", @(src, event) plotFunction()); 

    qLabel = uilabel(rightPanel, "Text", "q(t)");
    qValue = uieditfield(rightPanel, "text", ...
        "Value", "-5*sin(1*t)", ... 
        "ValueChangedFcn", @(src, event) plotFunction());

    iLabel = uilabel(rightPanel, "Text", "I(t)");
    iValue = uieditfield(rightPanel, "text", ...
        "Value", "-5*sin(1*t)", ... 
        "ValueChangedFcn", @(src, event) plotFunction());

        solutionAtTLabel = uilabel(rightPanel, "Text", "x(t): ");

        % Equation solution
        solutionLabel = uilabel(rightPanel, "Text", "Solución de la ecuación: ", "WordWrap","on");
    
        % Alternative solution
        alternativeSolutionLabel = uilabel(rightPanel, "Text", "Forma alternativa de la ecuación: ");

        % Sets the position of the elements
        positions();
    
    % Define callback function
    fig.SizeChangedFcn = @(src, event) figSizeChange(src, leftPanel, rightPanel, ...
        bg);
    
    
    figSizeChange(fig, leftPanel, rightPanel, bg);
    
    % Resizes the panels
    function figSizeChange(figHandle, leftPanelHandle, rightPanelHandle, bgHandle)
        pos = figHandle.Position;
        minWidth = 275;
        newWidth = pos(3) * 0.3;
        
        if newWidth < minWidth
            leftPanelHandle.Position(3) = minWidth;
            rightPanelHandle.Position = [minWidth, 0, pos(3) - minWidth, pos(4)];
        else
            leftPanelHandle.Position(3) = newWidth;
            rightPanelHandle.Position = [newWidth, 0, pos(3) - newWidth, pos(4)];
        end
        
        leftPanelHandle.Position(4) = pos(4);
        bgHandle.Position(2) = pos(4)-150;
    end

    function hideAllElements()
        % Hide each UI component
        weightLabel.Visible     = 'off';
        weight.Visible          = 'off';
        
        kLabel.Visible          = 'off';
        kValue.Visible          = 'off';
        
        wSquaredLabel.Visible   = 'off';
        wSquaredValue.Visible   = 'off';
        
        wLabel.Visible          = 'off';
        wValue.Visible          = 'off';
        
        massLabel.Visible       = 'off';
        massValue.Visible       = 'off';

        betaLabel.Visible       = 'off';
        betaValue.Visible       = 'off';

        lambdaLabel.Visible     = 'off';
        lambdaValue.Visible     = 'off';
        
        xLabel.Visible          = 'off';
        xValue.Visible          = 'off';

        F0Label.Visible         = 'off';
        F0Value.Visible         = 'off';

        lLabel.Visible          = 'off';
        lValue.Visible          = 'off';

        rLabel.Visible          = 'off';
        rValue.Visible          = 'off';

        cLabel.Visible          = 'off';
        cValue.Visible          = 'off';

        qLabel.Visible          = 'off';
        qValue.Visible          = 'off';

        iLabel.Visible          = 'off';
        iValue.Visible          = 'off';

        t1Label.Text = "t1 (Tiempo para x1)";
        xt1Label.Text = "x1(t1) (Posición)";
        t2Label.Text = "t2 (Tiempo para x2')";
        xt2Label.Text = "x2'(t2) (Velocidad)";

        alternativeSolutionLabel.Visible = 'off';
    end


    function positions()
        hideAllElements();

        % Plots the function
        plotFunction();

        switch application
            case 0
                undampedPostions();
            case 1
                dampedPositions();
            case 2
                forzedPositions();
            case 3
                chargePositions();
            case 4
                currentPositions();
        end
    end

    function undampedPostions()
        % Weight
        weightLabel.Position = [10, 920, 150, 22];
        weightLabel.Visible = 'on';
        weight.Position = [10, 900, 100, 22];
        weight.Visible = 'on';
        
        % Spring constant
        kLabel.Position = [10, 870, 150, 22];
        kLabel.Visible = 'on';
        kValue.Position = [10, 850, 100, 22];
        kValue.Visible = 'on';
        
        % Omega squared
        wSquaredLabel.Position = [10, 820, 150, 22];
        wSquaredLabel.Visible = 'on';
        wSquaredValue.Position = [10, 800, 100, 22];
        wSquaredValue.Visible = 'on';
        
        % Omega
        wLabel.Position = [10, 770, 150, 22];
        wLabel.Visible = 'on';
        wValue.Position = [10, 750, 100, 22];
        wValue.Visible = 'on';
        
        % Mass
        massLabel.Position = [10, 720, 150, 22];
        massLabel.Visible = 'on';
        massValue.Position = [10, 700, 100, 22];
        massValue.Visible = 'on';
    
        % X
        xLabel.Position = [10, 670, 150, 22];
        xLabel.Visible = 'on';
        xValue.Position = [10, 650, 100, 22];
        xValue.Visible = 'on';
    
        % Time
        tLabel.Position = [10, 620, 150, 22];
        tValue.Position = [10, 600, 100, 22];
    
        % t1
        t1Label.Position = [10, 570, 150, 22];
        t1Value.Position = [10, 550, 100, 22];
    
        % t2
        t2Label.Position = [10, 520, 150, 22];
        t2Value.Position = [10, 500, 100, 22];
    
        % xt1
        xt1Label.Position = [10, 470, 150, 22];
        xt1Value.Position = [10, 450, 100, 22];
    
        % xt2
        xt2Label.Position = [10, 420, 150, 22];
        xt2Value.Position = [10, 400, 100, 22];
        
        % Solution
        solutionAtTLabel.Position = [10, 370, 500, 22];
        solutionLabel.Position = [10, 350, 500, 22];
        alternativeSolutionLabel.Position = [10, 330, 500, 22];
        alternativeSolutionLabel.Visible = 'on';
    end

    function dampedPositions()
        % Weight
        weightLabel.Position = [10, 1020, 150, 22];
        weightLabel.Visible = 'on';
        weight.Position = [10, 1000, 100, 22];
        weight.Visible = 'on';
        
        % Spring constant
        kLabel.Position = [10, 970, 150, 22];
        kLabel.Visible = 'on';
        kValue.Position = [10, 950, 100, 22];
        kValue.Visible = 'on';
        
        % Omega squared
        wSquaredLabel.Position = [10, 920, 150, 22];
        wSquaredLabel.Visible = 'on';
        wSquaredValue.Position = [10, 900, 100, 22];
        wSquaredValue.Visible = 'on';
        
        % Omega
        wLabel.Position = [10, 870, 150, 22];
        wLabel.Visible = 'on';
        wValue.Position = [10, 850, 100, 22];
        wValue.Visible = 'on';
        
        % Mass
        massLabel.Position = [10, 820, 150, 22];
        massLabel.Visible = 'on';
        massValue.Position = [10, 800, 100, 22];
        massValue.Visible = 'on';

        % Beta
        betaLabel.Position = [10, 770, 100, 22];
        betaLabel.Visible = 'on';
        betaValue.Position = [10, 750, 100, 22];
        betaValue.Visible = 'on';

        % Lambda
        lambdaLabel.Position = [10, 720, 100, 22];
        lambdaLabel.Visible = 'on';
        lambdaValue.Position = [10, 700, 100, 22];
        lambdaValue.Visible = 'on';
    
        % X
        xLabel.Position = [10, 670, 150, 22];
        xLabel.Visible = 'on';
        xValue.Position = [10, 650, 100, 22];
        xValue.Visible = 'on';
    
        % Time
        tLabel.Position = [10, 620, 150, 22];
        tValue.Position = [10, 600, 100, 22];
    
        % t1
        t1Label.Position = [10, 570, 150, 22];
        t1Value.Position = [10, 550, 100, 22];
    
        % t2
        t2Label.Position = [10, 520, 150, 22];
        t2Value.Position = [10, 500, 100, 22];
    
        % xt1
        xt1Label.Position = [10, 470, 150, 22];
        xt1Value.Position = [10, 450, 100, 22];
    
        % xt2
        xt2Label.Position = [10, 420, 150, 22];
        xt2Value.Position = [10, 400, 100, 22];
        
        % Solution
        solutionAtTLabel.Position = [10, 370, 500, 22];
        solutionLabel.Position = [10, 350, 500, 22];
    end

    function forzedPositions()
        currentY = 1250; % Posición Y inicial
        verticalStep = 50; % Espaciado vertical entre elementos

        % Weight (W)
        weightLabel.Position = [10, currentY, 150, 22];
        weightLabel.Visible = 'on';
        weight.Position = [10, currentY-20, 100, 22];
        weight.Visible = 'on';
        currentY = currentY - verticalStep;

        % Spring Constant (K)
        kLabel.Position = [10, currentY, 150, 22];
        kLabel.Visible = 'on';
        kValue.Position = [10, currentY-20, 100, 22];
        kValue.Visible = 'on';
        currentY = currentY - verticalStep;

        % Omega squared (ω²)
        wSquaredLabel.Position = [10, currentY, 150, 22];
        wSquaredLabel.Visible = 'on'; % ←¡Habilitar visibilidad!
        wSquaredValue.Position = [10, currentY-20, 100, 22];
        wSquaredValue.Visible = 'on';
        currentY = currentY - verticalStep;

        % Omega (ω)
        wLabel.Position = [10, currentY, 150, 22];
        wLabel.Visible = 'on'; % ←¡Habilitar visibilidad!
        wValue.Position = [10, currentY-20, 100, 22];
        wValue.Visible = 'on';
        currentY = currentY - verticalStep;

        % X (Alargamiento)
        xLabel.Position = [10, currentY, 150, 22];
        xLabel.Visible = 'on'; % ←¡Habilitar visibilidad!
        xValue.Position = [10, currentY-20, 100, 22];
        xValue.Visible = 'on';
        currentY = currentY - verticalStep;

        % Mass (m)
        massLabel.Position = [10, currentY, 150, 22];
        massLabel.Visible = 'on';
        massValue.Position = [10, currentY-20, 100, 22];
        massValue.Visible = 'on';
        currentY = currentY - verticalStep;

        % Beta (β)
        betaLabel.Position = [10, currentY, 150, 22];
        betaLabel.Visible = 'on';
        betaValue.Position = [10, currentY-20, 100, 22];
        betaValue.Visible = 'on';
        currentY = currentY - verticalStep;

        % Lambda (λ)
        lambdaLabel.Position = [10, currentY, 150, 22];
        lambdaLabel.Visible = 'on';
        lambdaValue.Position = [10, currentY-20, 100, 22];
        lambdaValue.Visible = 'on';
        currentY = currentY - verticalStep;

        % Fuerza Externa (F0)
        F0Label.Position = [10, currentY, 150, 22];
        F0Label.Visible = 'on';
        F0Value.Position = [10, currentY-20, 100, 22];
        F0Value.Visible = 'on';
        currentY = currentY - verticalStep;

        % Time
        tLabel.Position = [10, currentY, 150, 22];
        tValue.Position = [10, currentY-20, 100, 22];
        currentY = currentY - 50;

        % t1 (tiempo para posición)
        t1Label.Text = "t1 (Tiempo para x1)";
        t1Label.Position = [10, currentY, 150, 22];
        t1Value.Position = [10, currentY-20, 100, 22];
        currentY = currentY - 50;

        % x1(t1)
        xt1Label.Text = "x1(t1) (Posición)";
        xt1Label.Position = [10, currentY, 150, 22];
        xt1Value.Position = [10, currentY-20, 100, 22];
        currentY = currentY - 50;

        % t2 (tiempo para velocidad)
        t2Label.Text = "t2 (Tiempo para x2')";
        t2Label.Position = [10, currentY, 150, 22];
        t2Value.Position = [10, currentY-20, 100, 22];
        currentY = currentY - 50;

        % x2'(t2) (velocidad)
        xt2Label.Text = "x2'(t2) (Velocidad)";
        xt2Label.Position = [10, currentY, 150, 22];
        xt2Value.Position = [10, currentY-20, 100, 22];
        currentY = currentY - 50;

        solutionAtTLabel.Position = [10, currentY, 500, 22];
        solutionLabel.Position = [10, currentY-220, 1000, 220];
    end

    function chargePositions()
        currentY = 1000; % Posición Y inicial
        verticalStep = 50; % Espaciado vertical entre elementos

        % L
        lLabel.Position = [10, currentY, 150, 22];
        lLabel.Visible = 'on';
        lValue.Position = [10, currentY-20, 100, 22];
        lValue.Visible = 'on';
        currentY = currentY - verticalStep;

        % R
        rLabel.Position = [10, currentY, 150, 22];
        rLabel.Visible = 'on';
        rValue.Position = [10, currentY-20, 100, 22];
        rValue.Visible = 'on';
        currentY = currentY - verticalStep;

        % C
        cLabel.Position = [10, currentY, 150, 22];
        cLabel.Visible = 'on';
        cValue.Position = [10, currentY-20, 100, 22];
        cValue.Visible = 'on';
        currentY = currentY - verticalStep;

        % q(t)
        qLabel.Position = [10, currentY, 150, 22];
        qLabel.Visible = 'on';
        qValue.Position = [10, currentY-20, 100, 22];
        qValue.Visible = 'on';
        currentY = currentY - verticalStep;

        % Time
        tLabel.Position = [10, currentY, 150, 22];
        tValue.Position = [10, currentY-20, 100, 22];
        currentY = currentY - 50;

        % t1 (tiempo para carga)
        t1Label.Text = "t1 (Tiempo para q)";
        t1Label.Position = [10, currentY, 150, 22];
        t1Value.Position = [10, currentY-20, 100, 22];
        currentY = currentY - verticalStep;

        % q(t1)
        xt1Label.Text = "q(t1) (Carga)";
        xt1Label.Position = [10, currentY, 150, 22];
        xt1Value.Position = [10, currentY-20, 100, 22];
        currentY = currentY - verticalStep;

        % t2 (tiempo para corriente)
        t2Label.Text = "t2 (Tiempo para I)";
        t2Label.Position = [10, currentY, 150, 22];
        t2Value.Position = [10, currentY-20, 100, 22];
        currentY = currentY - verticalStep;

        % I(t2) (Corriente)
        xt2Label.Text = "I(t2) (Corriente)";
        xt2Label.Position = [10, currentY, 150, 22];
        xt2Value.Position = [10, currentY-20, 100, 22];
        currentY = currentY - 50;

        solutionAtTLabel.Position = [10, currentY, 800, 22];
        solutionLabel.Position = [10, currentY-220, 1000, 220];
    end

    function currentPositions()
        currentY = 1000; % Posición Y inicial
        verticalStep = 50; % Espaciado vertical entre elementos

        % L
        lLabel.Position = [10, currentY, 150, 22];
        lLabel.Visible = 'on';
        lValue.Position = [10, currentY-20, 100, 22];
        lValue.Visible = 'on';
        currentY = currentY - verticalStep;

        % R
        rLabel.Position = [10, currentY, 150, 22];
        rLabel.Visible = 'on';
        rValue.Position = [10, currentY-20, 100, 22];
        rValue.Visible = 'on';
        currentY = currentY - verticalStep;

        % C
        cLabel.Position = [10, currentY, 150, 22];
        cLabel.Visible = 'on';
        cValue.Position = [10, currentY-20, 100, 22];
        cValue.Visible = 'on';
        currentY = currentY - verticalStep;

        % I(t)
        iLabel.Position = [10, currentY, 150, 22];
        iLabel.Visible = 'on';
        iValue.Position = [10, currentY-20, 100, 22];
        iValue.Visible = 'on';
        currentY = currentY - verticalStep;

        % Time
        tLabel.Position = [10, currentY, 150, 22];
        tValue.Position = [10, currentY-20, 100, 22];
        currentY = currentY - 50;

        % t1 (tiempo para carga)
        t1Label.Text = "t1 (Tiempo para I)";
        t1Label.Position = [10, currentY, 150, 22];
        t1Value.Position = [10, currentY-20, 100, 22];
        currentY = currentY - verticalStep;

        % q(t1)
        xt1Label.Text = "I(t1) (Corriente)";
        xt1Label.Position = [10, currentY, 150, 22];
        xt1Value.Position = [10, currentY-20, 100, 22];
        currentY = currentY - verticalStep;

        % t2 (tiempo para derivada)
        t2Label.Text = "t2 (Tiempo para I')";
        t2Label.Position = [10, currentY, 150, 22];
        t2Value.Position = [10, currentY-20, 100, 22];
        currentY = currentY - verticalStep;

        % I(t2) (Corriente)
        xt2Label.Text = "I'(t2)";
        xt2Label.Position = [10, currentY, 150, 22];
        xt2Value.Position = [10, currentY-20, 100, 22];
        currentY = currentY - 50;

        solutionAtTLabel.Position = [10, currentY, 800, 22];
        solutionLabel.Position = [10, currentY-220, 1000, 220];
    end


    function plotFunction()
        cla(ax);                         % Limpiar ejes antes de graficar
        grid(ax, 'on');
        switch application
            case 0
                plotUndamped();
            case 1
                plotDamped();
            case 2
                plotForzed();
            case 3
                plotCharge();
            case 4
                plotCurrent();
        end
    end

    function plotUndamped()
        % Initialize variables
        w = wValue.Value;
        wSquared = wSquaredValue.Value;
        x = xValue.Value;
        t1 = t1Value.Value;
        t2 = t2Value.Value;
        xt1 = xt1Value.Value;
        xt2 = xt2Value.Value;
        current_time = tValue.Value;

        % Check the values that need to be calculated
        if w == 0
            if wSquared == 0
                k = kValue.Value;
                % It suddenly turned into spanish
                peso = weight.Value;
                m = massValue.Value;

                if m == 0
                    if peso == 0
                            errordlg('Error: not enough data');
                        return;
                    end
                    m = peso / 32;
                end

                if peso == 0
                    peso = m * 32;
                end

                if k == 0
                    k = peso / x;
                end

                wSquared = k / m;
            end

            w = sqrt(wSquared);
        end

        % Solve for the constants of the equation
        A = [cos(w * t1), sin(w * t1); ...
            (-1 * w * sin(w * t2)), ...
            (w * cos(w * t2)) ]; 

        B = [xt1; xt2];

        constants = A \ B;

        solutionAtTLabel.Text = "x(" + current_time + ") = " + string(constants(1) * cos(w * ...
            current_time) + constants(2) * sin(w * current_time));

        % Equation solution
        solutionLabel.Text = "Solución de la ecuación: ";
        addPlus = false;
        if constants(1) ~= 0
            solutionLabel.Text = solutionLabel.Text ...
                + string(constants(1)) ...
                + "cos(" + string(w) + "t)";
            addPlus = true;
        end
        if constants(2) ~= 0
            if addPlus
                solutionLabel.Text = solutionLabel.Text + " + ";
            end
            solutionLabel.Text = solutionLabel.Text ...
                + string(constants(2)) ...
                + "sin(" + string(w) + "t)";
        end

    
        % Alternative solution
        % First and Fourth quadrant
        if (constants(1) > 0 && constants(2) > 0) || (constants(1) < 0 && constants(2) > 0)
            A = (constants(1).^2 + constants(2).^2).^(1/2);
            angle = atan(constants(1) / constants(2));
            alternativeSolutionLabel.Text = "Forma alternativa de la ecuación: "...
                + string(A) + "sen(" + string(w) + ...
                "t + " + string(angle) + ")";
        elseif (constants(1) > 0 && constants(2) < 0) || (constants(1) < 0 && constants(2) < 0)
            A = (constants(1).^2 + constants(2).^2).^(1/2);
            angle = atan(constants(1) / constants(2)) + pi;
            alternativeSolutionLabel.Text = "Forma alternativa de la ecuación: "...
                + string(A) + "sen(" + string(w) + ...
                "t + " + string(angle) + ")";
        else
            alternativeSolutionLabel.Text = "";
        end


        % Plots the function
        x = linspace(0, 100, 10000);
        y = constants(1) * cos(w * x) + constants(2) * sin(w * x);

        plot(ax, x, y);
        title(ax, 'Resortes: Movimiento no amortiguado');
        yline(ax, 0, 'k-', 'LineWidth', 1.5);
    end

 function plotDamped()
% Initialize variables
    w = wValue.Value;
    wSquared = wSquaredValue.Value;
    x = xValue.Value;
    beta = betaValue.Value;
    twoLambda = lambdaValue.Value;
    t1 = t1Value.Value;
    t2 = t2Value.Value;
    xt1 = xt1Value.Value;
    xt2 = xt2Value.Value;
    current_time = tValue.Value;

    % Check the values that need to be calculated
    if w == 0
        if wSquared == 0
            k = kValue.Value;
            % It suddenly turned into spanish
            peso = weight.Value;
            m = massValue.Value;

            if m == 0
                if peso == 0
                        errordlg('Error: not enough data');
                    return;
                end
                m = peso / 32;
            end

            if peso == 0
                peso = m * 32
            end

            if k == 0
                k = peso / x
            end

            wSquared = k / m
        end

        w = sqrt(wSquared);
    end
    if twoLambda == 0
        if beta == 0
            errordlg('Error: not enough data');
        end

        twoLambda = beta / m;
    end

    if beta == 0
        beta = twoLambda * m;
    end

    lambda = twoLambda / 2;
    root = lambda.^2 - wSquared;
    
    if root > 0
        % Overdamped case: two real distinct roots
        r1 = -lambda + sqrt(root);
        r2 = -lambda - sqrt(root);
        
        % Solve for the constants of the equation
        A = [exp(r1 * t1), exp(r2 * t1); ...
             r1 * exp(r1 * t2), r2 * exp(r2 * t2)];
        B = [xt1; xt2];
        constants = A \ B;
        
        % Display solution at time t
        solutionAtTLabel.Text = "x(" + current_time + ") = " + string(constants(1) * exp(r1 * current_time) + ...
                                constants(2) * exp(r2 * current_time));
        
        % Equation solution
        solutionLabel.Text = "Solución de la ecuación: ";
        addPlus = false;
        
        if constants(1) ~= 0
            solutionLabel.Text = solutionLabel.Text + ...
                string(constants(1)) + "e^(" + string(r1) + "t)";
            addPlus = true;
        end
        
        if constants(2) ~= 0
            if addPlus
                solutionLabel.Text = solutionLabel.Text + " + ";
            end
            solutionLabel.Text = solutionLabel.Text + ...
                string(constants(2)) + "e^(" + string(r2) + "t)";
        end
        
        if constants(1) == 0 && constants(2) == 0
            solutionLabel.Text = solutionLabel.Text + "0";
        end
        
        % No alternative solution for overdamped case
        alternativeSolutionLabel.Text = "";
        
        % Plot the function
        x = linspace(0, 100, 10000);
        y = constants(1) * exp(r1 * x) + constants(2) * exp(r2 * x);
        plot(ax, x, y);
        title(ax, 'Resortes: Movimiento sobreamortiguado');
        yline(ax, 0, 'k-', 'LineWidth', 1.5);
        
    elseif root == 0
        % Critically damped case: repeated real root
        r = -lambda;
        
        % Solve for the constants of the equation
        A = [exp(r * t1), t1 * exp(r * t1); ...
             r * exp(r * t2), ...
             r * t2 * exp(r * t2) + exp(r * t2)];
        B = [xt1; xt2];
        constants = A \ B;
        
        % Display solution at time t
        solutionAtTLabel.Text = "x( " + current_time + ") = " + string(constants(1) * exp(r * current_time) + ...
                               constants(2) * current_time * exp(r * current_time));
        
        % Equation solution
        solutionLabel.Text = "Solución de la ecuación: ";
        addPlus = false;
        
        if constants(1) ~= 0
            solutionLabel.Text = solutionLabel.Text + ...
                string(constants(1)) + "e^(" + string(r) + "t)";
            addPlus = true;
        end
        
        if constants(2) ~= 0
            if addPlus
                solutionLabel.Text = solutionLabel.Text + " + ";
            end
            solutionLabel.Text = solutionLabel.Text + ...
                string(constants(2)) + "t·e^(" + string(r) + "t)";
        end
        
        if constants(1) == 0 && constants(2) == 0
            solutionLabel.Text = solutionLabel.Text + "0";
        end
        
        % No alternative solution for critically damped case
        alternativeSolutionLabel.Text = "";
        
        % Plot the function
        x = linspace(0, 100, 10000);
        y = constants(1) * exp(r * x) + constants(2) * x .* exp(r * x);
        plot(ax, x, y);
        title(ax, 'Resortes: Movimiento críticamente amortiguado');
        yline(ax, 0, 'k-', 'LineWidth', 1.5);
        
    else
        % Underdamped case: complex conjugate roots
        w_d = sqrt(-root);  % Damped natural frequency
        
        % Solve for the constants of the equation
        A = [exp(-lambda * t1) * cos(w_d * t1), ...
             exp(-lambda * t1) * sin(w_d * t1); ...
             ((-lambda) * exp(-lambda * t2) * cos(w_d * t2) - exp(-lambda * t2) * w_d * sin(w_d * t2)), ...
             (-lambda) * exp(-lambda * t2) * sin(w_d * t2) + exp(-lambda * t2) * w_d * cos(w_d * t2)];
        B = [xt1; xt2];
        constants = A \ B;
        
        % Display solution at time t
        solutionAtTLabel.Text = "x(" + current_time + ") = " + ...
            string(exp(-lambda * current_time) * (constants(1) * cos(w_d * current_time) + ...
            constants(2) * sin(w_d * current_time)));
        
        % Equation solution
        solutionLabel.Text = "Solución de la ecuación: e^(-" + string(lambda) + "t)·(";
        addPlus = false;
        
        if constants(1) ~= 0
            solutionLabel.Text = solutionLabel.Text + ...
                string(constants(1)) + "cos(" + string(w_d) + "t)";
            addPlus = true;
        end
        
        if constants(2) ~= 0
            if addPlus
                solutionLabel.Text = solutionLabel.Text + " + ";
            end
            solutionLabel.Text = solutionLabel.Text + ...
                string(constants(2)) + "sin(" + string(w_d) + "t)";
        end
        
        if constants(1) == 0 && constants(2) == 0
            solutionLabel.Text = solutionLabel.Text + "0";
        end
        
        solutionLabel.Text = solutionLabel.Text + ")";
        
        % Alternative solution using amplitude and phase
        if constants(1) ~= 0 || constants(2) ~= 0
            A = sqrt(constants(1)^2 + constants(2)^2);
            phi = atan2(constants(2), constants(1));
            
            alternativeSolutionLabel.Text = "Forma alternativa de la ecuación: " + ...
                string(A) + "e^(-" + string(lambda) + "t)·sin(" + ...
                string(w_d) + "t + " + string(phi) + ")";
        else
            alternativeSolutionLabel.Text = "";
        end
        
        % Plot the function
        x = linspace(0, 100, 10000);
        y = exp(-lambda * x) .* (constants(1) * cos(w_d * x) + constants(2) * sin(w_d * x));
        plot(ax, x, y);
        title(ax, 'Resortes: Movimiento subamortiguado');
        yline(ax, 0, 'k-', 'LineWidth', 1.5);
    end
end

    function plotForzed()
w = wValue.Value;
        wSquared = wSquaredValue.Value;
        x = xValue.Value;
        beta = betaValue.Value;
        twoLambda = lambdaValue.Value;
        m = massValue.Value;
        k = kValue.Value;
        F_t_str = F0Value.Value;
    
        % Check the values that need to be calculated
        if w == 0
            if wSquared == 0
                % It suddenly turned into spanish
                peso = weight.Value;
    
                if m == 0
                    if peso == 0
                            errordlg('Error: not enough data');
                        return;
                    end
                    m = peso / 32;
                end
    
                if peso == 0
                    peso = m * 32
                end
    
                if k == 0
                    k = peso / x
                end
    
                wSquared = k / m
            end
    
            w = sqrt(wSquared);
        end
        if twoLambda == 0
            if beta == 0
                errordlg('Error: not enough data');
            end
    
            twoLambda = beta / m;
        end
    
        if beta == 0
            beta = twoLambda * m;
        end

        plotNoHomogeneus(m, beta, k, F_t_str, "Movimiento forzado", "x (Desplazamiento)")
    end

    function plotCharge()
        m = lValue.Value;
        beta = rValue.Value;
        k = 1 / cValue.Value;
        F_t_str = qValue.Value;
        plotNoHomogeneus(m, beta, k, F_t_str, "Circuito análogo en serie", "q (Carga)")
    end

    function plotCurrent()
        m = lValue.Value;
        beta = rValue.Value;
        k = 1 / cValue.Value;
        F_t_str = iValue.Value;
        plotNoHomogeneus(m, beta, k, F_t_str, "Circuito análogo en serie", "I (Corriente)")
    end

function plotNoHomogeneus(m, beta, k, F_t_str, plotTitle, yAxisTitle)
    try
        % --- Obtener parámetros de la interfaz ---
        t1 = t1Value.Value;
        x1 = xt1Value.Value;
        t2 = t2Value.Value;
        x2_prime = xt2Value.Value;
        current_time = tValue.Value;
    
        % --- Definir variable simbólica y resolver simbólicamente ---
        t     = sym('t');  
        y_sym = symfun( str2sym('y(t)'), t );   % y_sym is now a symbolic function of t
        
        Dy  = diff(y_sym, t);
        D2y = diff(y_sym, t, 2);
        
        % Convertir la fuerza en función simbólica
        f_sym = str2sym(F_t_str);
        
        % Definir la ecuación diferencial
        eqn = D2y + (beta/m)*Dy + (k/m)*y_sym == f_sym;
        
        % Condiciones iniciales
        cond1 = y_sym(t1)   == x1;
        cond2 = Dy(t2)      == x2_prime;
        
        % Resolver
        ySol = dsolve(eqn, cond1, cond2);
        
        % Mostrar la solución en el label
        solutionLabel.Text = sprintf('Solución: y(t) = %s', ySol);
    
        % --- Preparar plot ---
        % Convertir solución simbólica a función numérica
        y_fun = matlabFunction(ySol, 'Vars', t);
    
        t_vec = linspace(0, 100, 10000);
    
        % Evaluar la solución
        y_vec = y_fun(t_vec);

        % Display solution at time t
        solutionAtTLabel.Text = "x(" + current_time + ") = " + ...
            string(y_fun(current_time));
    
        % --- Graficar ---
        cla(ax);                         % Limpiar ejes antes de graficar
        plot(ax, t_vec, y_vec, 'LineWidth', 1.8);
        hold(ax, 'on');
        yline(ax, 0, 'k-', 'LineWidth', 1.2);
        hold(ax, 'off');
        
        title(ax, plotTitle, 'Interpreter', 'none');
        xlabel(ax, 'Tiempo (s)');
        ylabel(ax, yAxisTitle);
        grid(ax, 'on');
    catch ME
        errordlg()
    end
end
end