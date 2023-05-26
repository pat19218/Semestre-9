function D = inertia_matrix(q1,q2,q3,dq1,dq2,dq3,r0,r1,r2,ell0,ell1,ell2,g,m1,m2,m3,Ix1,Iy1,Iz1,Ix2,Iy2,Iz2,Ix3,Iy3,Iz3)
%INERTIA_MATRIX
%    D = INERTIA_MATRIX(Q1,Q2,Q3,DQ1,DQ2,DQ3,R0,R1,R2,ELL0,ELL1,ELL2,G,M1,M2,M3,IX1,IY1,IZ1,IX2,IY2,IZ2,IX3,IY3,IZ3)

%    This function was generated by the Symbolic Math Toolbox version 8.6.
%    10-Nov-2020 18:30:16

t2 = cos(q2);
t3 = cos(q3);
t4 = q2+q3;
t5 = r1.^2;
t6 = r2.^2;
t7 = t2.^2;
t8 = ell1.*t3;
t9 = cos(t4);
t10 = m3.*t6;
t11 = r2+t8;
t12 = m3.*r2.*t11;
t13 = Ix3+t12;
D = reshape([Iz1+m3.*(ell1.*t2+r2.*t9).^2+Iz2.*t7+Iz3.*t9.^2+Iy2.*sin(q2).^2+Iy3.*sin(t4).^2+m2.*t5.*t7,0.0,0.0,0.0,Ix2+Ix3+t10+m2.*t5+ell1.^2.*m3+m3.*r2.*t8.*2.0,t13,0.0,t13,Ix3+t10],[3,3]);