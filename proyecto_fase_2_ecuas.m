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
        "Position", [10, 0, 250, 100], ...
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
            case "Circuito en serie análogo"
                application = 3;
        end
        positions();
    end

    btnUndamped = uiradiobutton(bg, "Value", 1, ...
        "Text", "Resortes: Movimiento libre no amortiguado", ...
        "Position", [0, 66, 250, 20]);
    
    btnDamped = uiradiobutton(bg, "Value", 0, ...
        "Text", "Resortes: Movimiento libre amortiguado", ...
        "Position", [0, 44, 250, 20]);
    
    btnForzed = uiradiobutton(bg, "Value", 0, ...
        "Text", "Resortes: Movimiento forzado", ...
        "Position", [0, 22, 250, 20]);
    
    btnCircuit = uiradiobutton(bg, "Value", 0, ...
        "Text", "Circuito en serie análogo", ...
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

    % Y (Frecuencia fuerza externa)
    gammaLabel = uilabel(rightPanel, "Text", "γ (Frecuencia)");
    
    gammaValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.2f rad/s", ...
        "Value", 5, ...
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

        solutionAtTLabel = uilabel(rightPanel, "Text", "x(t): ");

        % Equation solution
        solutionLabel = uilabel(rightPanel, "Text", "Solución de la ecuación: ");
    
        % Alternative solution
        alternativeSolutionLabel = uilabel(rightPanel, "Text", "Forma alternativa de la ecuación: ");

        % Sets the position of the elements
        positions();
    
    % Define callback function
    fig.SizeChangedFcn = @(src, event) figSizeChange(src, ax, leftPanel, rightPanel, ...
        bg);
    
    
    figSizeChange(fig, ax, leftPanel, rightPanel, bg);
    
    % Resizes the panels
    function figSizeChange(figHandle, ax, leftPanelHandle, rightPanelHandle, bgHandle)
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

    function onWeightChange(~, ~)
        massValue.Value = weight.Value / 32;
        kValue.Value = weight.Value / xValue.Value;
        wSquaredValue.Value = kValue.Value / massValue.Value;
        wValue.Value = sqrt(wSquaredValue.Value);
        lambdaValue.Value = betaValue.Value / massValue.Value;
        plotFunction();
    end
    
    function onKChange(~, ~)
        %weight.Value = kValue.Value * xValue.Value;
        %massValue.Value = weight.Value / 32;
        wSquaredValue.Value = kValue.Value / massValue.Value;
        wValue.Value = sqrt(wSquaredValue.Value);
        plotFunction();
    end
    
    function onMassChange(~, ~)
        weight.Value = massValue.Value * 32;
        kValue.Value = weight.Value / xValue.Value;
        wSquaredValue.Value = kValue.Value / massValue.Value;
        wValue.Value = sqrt(wSquaredValue.Value);
        lambdaValue.Value = betaValue.Value / massValue.Value;
        plotFunction();
    end

    function onBetaChange(~, ~)
        lambdaValue.Value = betaValue.Value / massValue.Value;
        plotFunction();
    end

    function onLambdaChange(~, ~)
        betaValue.Value = lambdaValue.Value * massValue.Value;
        plotFunction();
    end

    function onWSquaredChange(src, ~)
        kValue.Value = massValue.Value * src.Value;
        wValue.Value = sqrt(src.Value);
        plotFunction();
    end

    function onWChange(src, ~)
        wSquaredValue.Value = src.Value^2;
        kValue.Value = massValue.Value * wSquaredValue.Value;
        plotFunction();
    end

    function onXChange(~, ~)
        if ~isequal(kValue.Value, weight.Value / xValue.Value)
            kValue.Value = weight.Value / xValue.Value;
        end
        plotFunction();
    end
    
    function onTChange(~, ~)
        plotFunction();
    end
    
    function onT1Change(~, ~)
        plotFunction();
    end
    
    function onT2Change(~, ~)
        plotFunction();
    end

    function onXt1Change(~, ~)
        plotFunction();
    end
    
    function onXt2Change(~, ~)
        plotFunction();
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
        
        tLabel.Visible          = 'off';
        tValue.Visible          = 'off';
        
        t1Label.Visible         = 'off';
        t1Value.Visible         = 'off';
        
        t2Label.Visible         = 'off';
        t2Value.Visible         = 'off';
        
        xt1Label.Visible        = 'off';
        xt1Value.Visible        = 'off';
        
        xt2Label.Visible        = 'off';
        xt2Value.Visible        = 'off';

        F0Label.Visible         = 'off';
        F0Value.Visible         = 'off';
        
        %gammaLabel.Visible      = 'off';
        %gammaValue.Visible      = 'off';

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
        tLabel.Visible = 'on';
        tValue.Position = [10, 600, 100, 22];
        tValue.Visible = 'on';
    
        % t1
        t1Label.Position = [10, 570, 150, 22];
        t1Label.Visible = 'on';
        t1Value.Position = [10, 550, 100, 22];
        t1Value.Visible = 'on';
    
        % t2
        t2Label.Position = [10, 520, 150, 22];
        t2Label.Visible = 'on';
        t2Value.Position = [10, 500, 100, 22];
        t2Value.Visible = 'on';
    
        % xt1
        xt1Label.Position = [10, 470, 150, 22];
        xt1Label.Visible = 'on';
        xt1Value.Position = [10, 450, 100, 22];
        xt1Value.Visible = 'on';
    
        % xt2
        xt2Label.Position = [10, 420, 150, 22];
        xt2Label.Visible = 'on';
        xt2Value.Position = [10, 400, 100, 22];
        xt2Value.Visible = 'on';
        
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
        tLabel.Visible = 'on';
        tValue.Position = [10, 600, 100, 22];
        tValue.Visible = 'on';
    
        % t1
        t1Label.Position = [10, 570, 150, 22];
        t1Label.Visible = 'on';
        t1Value.Position = [10, 550, 100, 22];
        t1Value.Visible = 'on';
    
        % t2
        t2Label.Position = [10, 520, 150, 22];
        t2Label.Visible = 'on';
        t2Value.Position = [10, 500, 100, 22];
        t2Value.Visible = 'on';
    
        % xt1
        xt1Label.Position = [10, 470, 150, 22];
        xt1Label.Visible = 'on';
        xt1Value.Position = [10, 450, 100, 22];
        xt1Value.Visible = 'on';
    
        % xt2
        xt2Label.Position = [10, 420, 150, 22];
        xt2Label.Visible = 'on';
        xt2Value.Position = [10, 400, 100, 22];
        xt2Value.Visible = 'on';
        
        % Solution
        solutionAtTLabel.Position = [10, 370, 500, 22];
        solutionLabel.Position = [10, 350, 500, 22];
    end

    function forzedPositions()
        currentY = 1020; % Posición Y inicial
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

        % t1 (tiempo para posición)
        t1Label.Text = "t1 (Tiempo para x1)";
        t1Label.Position = [10, currentY, 150, 22];
        t1Label.Visible = 'on';
        t1Value.Position = [10, currentY-20, 100, 22];
        t1Value.Visible = 'on';
        currentY = currentY - 50;

        % x1(t1)
        xt1Label.Text = "x1(t1) (Posición)";
        xt1Label.Position = [10, currentY, 150, 22];
        xt1Label.Visible = 'on';
        xt1Value.Position = [10, currentY-20, 100, 22];
        xt1Value.Visible = 'on';
        currentY = currentY - 50;

        % t2 (tiempo para velocidad)
        t2Label.Text = "t2 (Tiempo para x2')";
        t2Label.Position = [10, currentY, 150, 22];
        t2Label.Visible = 'on';
        t2Value.Position = [10, currentY-20, 100, 22];
        t2Value.Visible = 'on';
        currentY = currentY - 50;

        % x2'(t2) (velocidad)
        xt2Label.Text = "x2'(t2) (Velocidad)";
        xt2Label.Position = [10, currentY, 150, 22];
        xt2Label.Visible = 'on';
        xt2Value.Position = [10, currentY-20, 100, 22];
        xt2Value.Visible = 'on';
    end


    function plotFunction()
        switch application
            case 0
                plotUndamped();
            case 1
                plotDamped();
            case 2
                plotForzed();
        end
    end

    function plotUndamped()
        % Solve for the constants of the equation
        A = [cos(wValue.Value * t1Value.Value), sin(wValue.Value * t1Value.Value); ...
            (-1 * wValue.Value * sin(wValue.Value * t2Value.Value)), ...
            (wValue.Value * cos(wValue.Value * t2Value.Value)) ]; 

        B = [xt1Value.Value; xt2Value.Value];

        constants = A \ B;

        solutionAtTLabel.Text = "x(t) = " + string(constants(1) * cos(wValue.Value * ...
            tValue.Value) + constants(2) * sin(wValue.Value * tValue.Value));

        % Equation solution
        solutionLabel.Text = "Solución de la ecuación: ";
        addPlus = false;
        if constants(1) ~= 0
            solutionLabel.Text = solutionLabel.Text ...
                + string(constants(1)) ...
                + "cos(" + string(wValue.Value) + "t)";
            addPlus = true;
        end
        if constants(2) ~= 0
            if addPlus
                solutionLabel.Text = solutionLabel.Text + " + ";
            end
            solutionLabel.Text = solutionLabel.Text ...
                + string(constants(2)) ...
                + "sin(" + string(wValue.Value) + "t)";
        end
        if constants(1) == 0 && constants(2) == 0
            solutionLabel.Text = solutionLabel.Text + "0";
        end

    
        % Alternative solution
        % First and Fourth quadrant
        if (constants(1) > 0 && constants(2) > 0) || (constants(1) < 0 && constants(2) > 0)
            A = (constants(1).^2 + constants(2).^2).^(1/2);
            angle = atan(constants(1) / constants(2));
            alternativeSolutionLabel.Text = "Forma alternativa de la ecuación: "...
                + string(A) + "sen(" + string(wValue.Value) + ...
                "t + " + string(angle) + ")";
        elseif (constants(1) > 0 && constants(2) < 0) || (constants(1) < 0 && constants(2) < 0)
            A = (constants(1).^2 + constants(2).^2).^(1/2);
            angle = atan(constants(1) / constants(2)) + pi;
            alternativeSolutionLabel.Text = "Forma alternativa de la ecuación: "...
                + string(A) + "sen(" + string(wValue.Value) + ...
                "t + " + string(angle) + ")";
        else
            alternativeSolutionLabel.Text = "";
        end


        % Plots the function
        x = linspace(0, 100, 10000);
        y = constants(1) * cos(wValue.Value * x) + constants(2) * sin(wValue.Value * x);

        plot(ax, x, y);
        yline(ax, 0, 'k-', 'LineWidth', 1.5);
    end

    function plotDamped()
        lambda = lambdaValue.Value / 2;
        root = lambda.^2 - wSquaredValue.Value;

        if root > 0
            
        elseif root == 0

        else
            
        end

    end

    function plotForzed()
    % --- Obtener parámetros de la interfaz ---
    m = massValue.Value;
    beta = betaValue.Value;
    k = kValue.Value;
    t1 = t1Value.Value;
    x1 = xt1Value.Value;
    t2 = t2Value.Value;
    x2_prime = xt2Value.Value;
    F_t_str = F0Value.Value;
    current_time = tValue.Value;

    % --- Inicializar variables ---
    yc = ''; % Forma simbólica de yc
    yp = '[Solución Particular]'; % Valor por defecto para yp
    C1 = nan;
    C2 = nan;
    t_sol = [];
    x_pos = [];
    current_position = 0;

    % --- Calcular solución homogénea simbólica (yc) ---
    lambda = beta / (2*m);
    omega_0 = sqrt(k/m);
    
    if lambda < omega_0
        omega_d = sqrt(omega_0^2 - lambda^2);
        yc = sprintf('e^{-%.2ft}(C₁cos(%.2ft) + C₂sin(%.2ft))', lambda, omega_d);
    elseif lambda > omega_0
        r1 = -lambda + sqrt(lambda^2 - omega_0^2);
        r2 = -lambda - sqrt(lambda^2 - omega_0^2);
        yc = sprintf('C₁e^{%.2ft} + C₂e^{%.2ft}', r1, r2);
    else
        yc = sprintf('(C₁ + C₂t)e^{-%.2ft}', lambda);
    end

    % --- Calcular solución particular (yp) ---
    try
        tokens = regexp(F_t_str, '(-?\d+\.?\d*)\*?(cos|sin|exp)?\(?(-?\d+\.?\d*)?t?\)?', 'tokens');
        if ~isempty(tokens)
            F0 = str2double(tokens{1}{1});
            func_type = tokens{1}{2};
            gamma = str2double(tokens{1}{3});
            
            switch func_type
                case {'cos', 'sin'}
                    X = F0 / sqrt((k - m*gamma^2)^2 + (beta*gamma)^2);
                    phi = atan2(beta*gamma, k - m*gamma^2);
                    yp = sprintf('%.2f%s(%.2ft - %.2f)', X, func_type, gamma, phi);
                case 'exp'
                    yp = sprintf('%.2fe^{%.2ft}', F0, gamma);
                otherwise
                    yp = F_t_str;
            end
        end
    catch
        % Mantener el valor por defecto de yp
    end

    % --- Resolver numéricamente y calcular C₁/C₂ ---
    try
        F_t = str2func(['@(t)' F_t_str]);
        
        if t1 == t2 % IVP (ode45)
            [t_sol, x_sol] = ode45(@(t,x) [x(2); (F_t(t) - beta*x(2) - k*x(1))/m], [t1, t1+10], [x1; x2_prime]);
            x_pos = x_sol(:, 1); % Columna 1: posición
            t_sol = t_sol(:); % Vector columna
            
            % Extraer condiciones para yc
            yc_t1 = x_sol(1, 1);
            yc_prime_t1 = x_sol(1, 2);
            
        else % BVP (bvp4c)
            sol = bvp4c(@(t,x) [x(2); (F_t(t) - beta*x(2) - k*x(1))/m], ...
                        @(xa,xb) [xa(1)-x1; xb(2)-x2_prime], ...
                        bvpinit(linspace(min(t1,t2), max(t1,t2), 100), [0; 0]));
            t_sol = linspace(min(t1,t2), max(t1,t2), 1000);
            x_sol = deval(sol, t_sol);
            x_pos = x_sol(1, :)'; % Fila 1: posición, convertida a columna
            t_sol = t_sol(:); % Vector columna
            
            % Extraer condiciones para yc
            yc_t1 = x_sol(1, 1);
            yc_prime_t1 = x_sol(2, 1);
        end

        % --- Calcular C₁ y C₂ ---
        if lambda < omega_0 % Subamortiguado
            omega_d = sqrt(omega_0^2 - lambda^2);
            A = [exp(-lambda*t1)*cos(omega_d*t1), exp(-lambda*t1)*sin(omega_d*t1);
                 exp(-lambda*t1)*(-lambda*cos(omega_d*t1) - omega_d*sin(omega_d*t1)), ...
                 exp(-lambda*t1)*(-lambda*sin(omega_d*t1) + omega_d*cos(omega_d*t1))];
            B = [yc_t1; yc_prime_t1];
            constants = A \ B;
            C1 = constants(1);
            C2 = constants(2);
            yc = sprintf('e^{-%.2ft}(%.2fcos(%.2ft) + %.2fsin(%.2ft))', lambda, C1, omega_d, C2, omega_d);
            
        elseif lambda > omega_0 % Sobreamortiguado
            r1 = -lambda + sqrt(lambda^2 - omega_0^2);
            r2 = -lambda - sqrt(lambda^2 - omega_0^2);
            A = [exp(r1*t1), exp(r2*t1);
                 r1*exp(r1*t1), r2*exp(r2*t1)];
            B = [yc_t1; yc_prime_t1];
            constants = A \ B;
            C1 = constants(1);
            C2 = constants(2);
            yc = sprintf('%.2fe^{%.2ft} + %.2fe^{%.2ft}', C1, r1, C2, r2);
            
        else % Críticamente amortiguado
            A = [exp(-lambda*t1), t1*exp(-lambda*t1);
                 -lambda*exp(-lambda*t1), exp(-lambda*t1)*(1 - lambda*t1)];
            B = [yc_t1; yc_prime_t1];
            constants = A \ B;
            C1 = constants(1);
            C2 = constants(2);
            yc = sprintf('(%.2f + %.2ft)e^{-%.2ft}', C1, C2, lambda);
        end
        
    catch ME
        errordlg(['Error: ' ME.message]);
    end

    % --- Manejar índices y actualizar etiquetas ---
    if ~isempty(t_sol)
        current_index = find(t_sol >= current_time, 1);
        if isempty(current_index)
            current_index = numel(t_sol);
        end
        current_position = x_pos(current_index);
    end
    
    solutionLabel.Text = sprintf('Solución: y(t) = %s + %s', yc, yp);
    solutionAtTLabel.Text = sprintf('x(%.2f s) = %.4f ft', current_time, current_position);

    % --- Graficar ---
    cla(ax);
    if ~isempty(t_sol) && ~isempty(x_pos)
        plot(ax, t_sol, x_pos, 'b-', 'LineWidth', 1.5);
        title(ax, 'Movimiento Forzado');
        xlabel(ax, 'Tiempo (s)');
        ylabel(ax, 'Desplazamiento (ft)');
        grid(ax, 'on');
        
        ax.XLim = [min(t_sol) max(t_sol)];  % Ajusta eje X al rango simulado
        ax.YLim = [min(x_pos)-0.5 max(x_pos)+0.5];  % Margen en Y
    end
    end
end