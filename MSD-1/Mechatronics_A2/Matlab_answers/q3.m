clc;
clear all;

%I am defining an array for taking input of side lengths
arr = zeros(1, 4); 

    for m=1:4
        fprintf('Enter value of side for side %d: ', m);
        arr(m) = input('');
    end

sorted_sides = sort(arr);

shortest=sorted_sides(1);
longest=sorted_sides(4);

%Let intput arr array elements represents ground, input, output and coupler
%bar dimensions, i.e first input will be ground bar length, second will be
%input bar length , third will be output bar length and 4th will be coupler
%bar length.

ground=arr(1);
input=arr(2);
output=arr(3);
coupler=arr(4);

if(sorted_sides(1)+sorted_sides(4)<=sorted_sides(2)+sorted_sides(3))
    fprintf('According to given link lengths the four bar mechanism is GRASHOF \n');
else
    fprintf('According to given link lengths the four bar mechanism is NON-GRASHOF\n ');
end

fprintf('Now we have given bar lengths input as :\n');
fprintf('ground = %d: \n', arr(1));
fprintf('input = %d: \n', arr(2));
fprintf('output = %d: \n', arr(3));
fprintf('coupler = %d: \n', arr(4));
    
if(sorted_sides(1)+sorted_sides(4)<sorted_sides(2)+sorted_sides(3))
    if(ground==shortest)
        fprintf('As Ground bar is the shortest in length, so all remaining 3 bars(input, output, coupler) acts as cranksi.r crank-crank-crank mechanism\n ');
    end
    if(input==shortest)
        fprintf('As input is of shortest length, so we  get crank-rocker-rocker mechanism with input->crank, output->rocker, coupler->rocker\n ');
    end
    if(output==shortest)
        fprintf('As output is of shortest length, so we  get rocker-rocker-crank mechanism with input->rocker, output->crank, coupler->rocker\n ');
    end
    if(coupler==shortest)
        fprintf('As coupler is of shortest length, so we  get rocker-crank-rocker mechanism with input->rocker, output->rocker, coupler->crank \n ');
    end
end
    

if((sorted_sides(1)+sorted_sides(4))==(sorted_sides(2)+sorted_sides(3)))
    if(ground==coupler && input==output)
        fprintf('Here S+L=P+Q and We get double crank inversions as this will be in parallelogram form  \n ');
    end
    if(ground~=coupler && input~=output)
        if(ground==shortest)
        fprintf('Here S+L=P+Q and We get double crank inversions as this will be in Deltoid or kite form with shortest side as ground i.e shortest side is fixed \n ');
        end
        if(ground==longest)
            fprintf('Here S+L=P+Q and We get crank-rocker inversions as this will be in Deltoid or kite form with longest side as ground i.e longest side is fixed \n ');
        end
    end
end


    