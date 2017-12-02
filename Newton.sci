function f=func(x)
    f=100*(x(2)-x(1)^2)^2+(1-x(1))^2
endfunction

function g=grad(x)
    g=[-400*x(1)*(x(2)-x(1)^2)-2*(1-x(1));200*(x(2)-x(1)^2)]
endfunction

function h=hes(x)
    h=[-400*(x(2)-3*x(1)^2)+2,-400*x(1);-400*x(1),200]
endfunction

function n=newf(x, aplha)
    x=x-alpha*(inv(hes(x))*grad(x))'
    n=func(x)
endfunction

x=[-2,1]

eps=1e-4
tol=1e3
mid = 0
for i=1:20000
    
    lo=-100
    hi=100
    
    while(lo>hi-tol)
       
       mid=(lo+hi)/2
       
       x1=lo
       x2=mid
       x3=hi
       
       y1=newf(x,x1)
       y2=newf(x,x2)
       y3=newf(x,x3)
       
        s21=(y2-y1)/(x2-x1)
        s32=(y3-y2)/(x3-x2)
       
       xm=(x1+x2)/2-s21*(x3-x1)/(2*(s32-s21))
       
       ym=newf(x,xm)
       
       if xm>x2 then
           if ym>y2 then
               hi=xm
           else    
               lo=x2
            end
        else
        if ym>y2 then
            lo=xm
            else          
             hi=x2
         end
     end 
        
    end  
    
    x=x-mid*(inv(hes(x))*grad(x))'  
    // x=x-mid*grad(x)'
end

disp(x)
disp(func(x))
