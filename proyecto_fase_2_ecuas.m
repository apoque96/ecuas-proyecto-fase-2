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
        "LowerLimitInclusive", "off", ...
        "ValueDisplayFormat", "%.2f lbs", ...
        "Value", 24, ...
        "ValueChangedFcn", @(src, event) onWeightChange(src, event));
    
    % K (Constante del resorte)
    kLabel = uilabel(rightPanel, "Text", "K (Constante del resorte)");
    
    kValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "off", ...
        "ValueDisplayFormat", "%.2f lb/ft", ...
        "Value", 72, ...
        "ValueChangedFcn", @(src, event) onKChange(src, event));
    
    % ω² (omega cuadrado)
    wSquaredLabel = uilabel(rightPanel, "Text", "ω² (omega cuadrado)");
    
    wSquaredValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "off", ...
        "ValueDisplayFormat", "%.4f", ...
        "Value", 96, ...
        "Editable", "off");
    
    % w (omega)
    wLabel = uilabel(rightPanel, "Text", "ω (omega)");
    
    wValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "off", ...
        "ValueDisplayFormat", "%.4f", ...
        "Value", 9.7980, ...
        "Editable", "off");
    
    % m (Masa)
    massLabel = uilabel(rightPanel, "Text", "m (Masa)");
    
    massValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "off", ...
        "ValueDisplayFormat", "%.2f slugs", ...
        "Value", 0.75, ...
        "ValueChangedFcn", @(src, event) onMassChange(src, event));

    % β
    betaLabel = uilabel(rightPanel, "Text", "β");
    
    betaValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "off", ...
        "ValueDisplayFormat", "%.2f", ...
        "Value", 0.5, ...
        "ValueChangedFcn", @(src, event) onBetaChange(src, event));

    % 2λ
    lambdaLabel = uilabel(rightPanel, "Text", "2λ");
    
    lambdaValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "off", ...
        "ValueDisplayFormat", "%.2f", ...
        "Value", 0.5, ...
        "ValueChangedFcn", @(src, event) onLambdaChange(src, event));

    % x (Alargamiento)
    xLabel = uilabel(rightPanel, "Text", "x (Alargamiento)");
    
    xValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [-1000000000 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.2f ft", ...
        "Value", 1/3, ...
        "ValueChangedFcn", @(src, event) onXChange(src, event));
    
    % t (tiempo)
    tLabel = uilabel(rightPanel, "Text", "t (tiempo)");
    
    tValue = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.2f s", ...
        "Value", 0, ...
        "ValueChangedFcn", @(src, event) onTChange(src, event));
    
    % t1 (tiempo)
    t1Label = uilabel(rightPanel, "Text", "t1 (tiempo)");
    
    t1Value = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.2f s", ...
        "Value", 0, ...
        "ValueChangedFcn", @(src, event) onT1Change(src, event));
    
    % t2 (tiempo)
    t2Label = uilabel(rightPanel, "Text", "t2 (tiempo)");
    
    t2Value = uieditfield(rightPanel, "numeric", ...
        "Limits", [0 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.2f s", ...
        "Value", 0, ...
        "ValueChangedFcn", @(src, event) onT2Change(src, event));
    
    % x(t1) (Distancia)
    xt1Label = uilabel(rightPanel, "Text", "x(t1) (Distancia)");
    
    xt1Value = uieditfield(rightPanel, "numeric", ...
        "Limits", [-1000000000 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.2f ft", ...
        "Value", -0.25, ...
        "ValueChangedFcn", @(src, event) onXt1Change(src, event));
    
    % x'(t2) (Distancia)
    xt2Label = uilabel(rightPanel, "Text", "x'(t2) (Distancia)");
    
    xt2Value = uieditfield(rightPanel, "numeric", ...
        "Limits", [-1000000000 1000000000], ...
        "LowerLimitInclusive", "on", ...
        "ValueDisplayFormat", "%.2f ft", ...
        "Value", 0, ...
        "ValueChangedFcn", @(src, event) onXt2Change(src, event));

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

    function onXChange(~, ~)
        kValue.Value = weight.Value / xValue.Value;
        wSquaredValue.Value = kValue.Value / massValue.Value;
        wValue.Value = sqrt(wSquaredValue.Value);
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


    function plotFunction()
        switch application
            case 0
                plotUndamped();
            case 1
                plotDamped();
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
end