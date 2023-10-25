function electric_field_simulation
   % Crear la figura de la interfaz gráfica
   mainFig = uifigure('Name', 'Simulación de campo eléctrico', 'Position', [100, 100, 800, 600], 'Color', [0.2, 0.2, 0.2]);
  
   % Crear un panel para contener el gráfico y los controles
   mainPanel = uipanel(mainFig, 'Position', [0, 0, 800, 600], 'BackgroundColor', [0.3, 0.3, 0.3]);
  
   % Crear el eje para el gráfico del campo eléctrico
   mainAxes = uiaxes(mainPanel, 'Position', [50, 150, 700, 400], 'Color', [0.9, 0.9, 0.9], 'XColor', [1, 1, 1], 'YColor', [1, 1, 1], 'GridColor', [0.5, 0.5, 0.5]);
  
   % Crear un botón para iniciar la simulación
   startButton = uibutton(mainPanel, 'push', 'Text', 'Iniciar simulación', 'Position', [350, 17, 150, 30], 'FontColor', [1, 1, 1], 'BackgroundColor', [0, 0.447, 0.741]);
   startButton.ButtonPushedFcn = @start_simulation;
  
   % Crear entrada para la longitud de la varilla (l)
   lInputLabel = uilabel(mainPanel, 'Text', 'Longitud de la varilla', 'Position', [50, 110, 130, 20], 'FontWeight', 'bold', 'FontColor', [1, 1, 1]);
   lInput = uieditfield(mainPanel, 'numeric', 'Position', [190, 110, 100, 20]);
   lInput.Value = 5; % Valor inicial
  
   % Crear entrada para el número de puntos en el grid (N)
   NInputLabel = uilabel(mainPanel, 'Text', 'Número de puntos en el grid (25 a 100)', 'Position', [50, 80, 210, 20], 'FontWeight', 'bold', 'FontColor', [1, 1, 1]);
   NInput = uislider(mainPanel, 'Position', [270, 80, 200, 3], 'Limits', [25, 100], 'Value', 50, 'MajorTicksMode', 'auto', 'MinorTicksMode', 'auto');
  
   % Crear entrada para el número de cargas (Nq)
   NqInputLabel = uilabel(mainPanel, 'Text', 'Número de cargas (50 a 100)', 'Position', [430, 80, 170, 20], 'FontWeight', 'bold', 'FontColor', [1, 1, 1]);
   NqInput = uislider(mainPanel, 'Position', [590, 80, 200, 3], 'Limits', [50, 100], 'Value', 100, 'MajorTicksMode', 'auto', 'MinorTicksMode', 'auto');
  
   function start_simulation(src, event)
       % Leer los valores de las entradas
       l = lInput.Value;
       N = round(NInput.Value);
       Nq = round(NqInput.Value);
      
       % Limpia el eje antes de la simulación
       cla(mainAxes);
      
       Xmin = -6;
       Xmax = 6;
       Ymin = -6;
       Ymax = 6;
       x = linspace(Xmin,Xmax, N);
       y = linspace(Ymin,Ymax, N);
       [X,Y] = meshgrid(x,y);
       % Campo eléctrico
       k = 1;
       Q = 1;
       w = 0.5;
       xQp = -3*w*ones(1,Nq);
       yQp = linspace(-l/2+w,l/2-w,Nq);
       xQn = 3*w*ones(1,Nq);
       yQn = linspace(-l/6+w,l/6-w,Nq);
       yQn2 = linspace(-l/4+w,l/4-w,Nq);
       lambda1 = (Q*Nq) / l;
       lambda2 = (Q*Nq) / (0.5*l);
       % Carga Positiva
       Ex = zeros(N);
       Ey = zeros(N);
       for i = 1:Nq
           Rx = X - xQp(i);
           Ry = Y - yQp(i);
           R = sqrt(Rx.^2 + Ry.^2).^3;
           Ex = Ex + k .* lambda1 .* Rx ./R;
           Ey = Ey + k .* lambda1 .* Ry ./R;
       end
       % Carga Negativa
       for i = 1:Nq
           Rx = X - xQn(i);
           Ry = Y - yQn(i);
           R = sqrt(Rx.^2 + Ry.^2).^3;
           Ex = Ex + k .* -lambda2 .* Rx ./R;
           Ey = Ey + k .* -lambda2 .* Ry ./R;
       end
       E = sqrt(Ex.^2 + Ey.^2);
       u = Ex./E;
       v = Ey./E;
       % Dibujar el campo
       quiver(mainAxes, X, Y, u, v, 'b', 'LineWidth', 1);
       axis(mainAxes, [-4 4 -4 4]);
       axis(mainAxes, 'equal');
       hold(mainAxes, 'on');
       % Agregar etiquetas a los ejes
       xlabel('Posición X');
       ylabel('Posición Y');
      
               for i = 1:Nq
           rectangle(mainAxes, 'Position', [xQp(i)-w/2 yQp(i)-w/2 w w], 'Curvature', [1 1], 'FaceColor', 'r');
       end
       % Placa Negativa
       for i = 1:Nq
           rectangle(mainAxes, 'Position', [xQn(i)-w/2 yQn2(i)-w/2 w w], 'Curvature', [1 1], 'FaceColor', 'b');
       end
       % Animación de círculos amarillos y negros
       num_circles = 10;
       circle_separation = 0.3;
       initial_positions = [linspace(-1, 1, num_circles)' linspace(-4, -4 - (num_circles - 1) * circle_separation, num_circles)'];
       initial_positions = initial_positions(randperm(size(initial_positions, 1)), :);
       initial_yellow_positions = initial_positions(1:num_circles/2, :);
       initial_black_positions = initial_positions(num_circles/2+1:end, :);
       final_yellow_positions = [1.4 * ones(num_circles/2, 1), 5 + linspace(0, -(num_circles/2 - 1) * circle_separation, num_circles/2)'];
       final_black_positions = [-1.4 * ones(num_circles/2, 1), 5 + linspace(0, -(num_circles/2 - 1) * circle_separation, num_circles/2)'];
       circle_radius = 0.2;
       yellow_circles = [];
       black_circles = [];
       for i = 1:num_circles/2
           yellow_circles = [yellow_circles; rectangle(mainAxes, 'Position', [initial_yellow_positions(i, :) - circle_radius, 2*circle_radius, 2*circle_radius], 'Curvature', [1 1], 'FaceColor', 'yellow', 'EdgeColor', 'none')];
           black_circles = [black_circles; rectangle(mainAxes, 'Position', [initial_black_positions(i, :) - circle_radius, 2*circle_radius, 2*circle_radius], 'Curvature', [1 1], 'FaceColor', 'black', 'EdgeColor', 'none')];
       end
       num_steps = 100;
       pause_time = 0.05;
       for step = 1:num_steps
           t = step / num_steps;
           current_yellow_positions = initial_yellow_positions + t * (final_yellow_positions - initial_yellow_positions);
           current_black_positions = initial_black_positions + t * (final_black_positions - initial_black_positions);
           for i = 1:num_circles/2
               yellow_circles(i).Position(1:2) = current_yellow_positions(i, :) - circle_radius;
               black_circles(i).Position(1:2) = current_black_positions(i, :) - circle_radius;
           end
           drawnow;
           pause(pause_time);
       end
   end
end
