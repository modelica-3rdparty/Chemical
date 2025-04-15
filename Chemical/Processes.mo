within Chemical;
package Processes "Undirected process package"
  model Reaction "Chemical Reaction"
    extends Chemical.Processes.Internal.PartialReactionWithProductsDefinition;
    extends Chemical.Interfaces.PartialSolutionSensor(solutionFrom = if nP==0 then SolutionChoice.Parameter else SolutionChoice.FirstSubstrate);

    import Chemical.Utilities.Types.SolutionChoice;
    import Chemical.Processes.Internal.Kinetics;

    replaceable function uLoss = Kinetics.generalPotentialLoss
      constrainedby
        Kinetics.partialPotentialLoss "Electro-chemical potential loss function"
      annotation(choicesAllMatching=true, Documentation(info="<html>
    <p>Electro-chemical potential loss function used in the diffusion.</p>
    </html>"));
    extends Chemical.Interfaces.ConditionalKinetics(k_forward=1);

    //Real rr_fore_exact,rr_rear_exact,  kb;

  equation

    //chemical kinetics
    du_fore = -uLoss(rr,kf,Sx_fore,solutionState);
    if nS>0 then
      du_rear = -uLoss(-rr,Kx*kf,Px_rear,solutionState);
    end if;

    //chemical solution and its propagation
    if nS>0 then
      connect(substrates[1].solution,inputSubstrateSolution);
      products.solution = fill(solutionState,nP);
    end if;


  /*  Kx = kb/kf;

  //the same as:
    rr_fore_exact = (kf*Sx_fore - kb*Px_fore);
    rr_rear_exact = (kb*Px_rear - kf*Sx_rear);
*/

    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{
            100,100}}),   graphics={
          Rectangle(
            extent={{-100,-30},{100,30}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,-72},{100,-40}},
            lineColor={128,0,255},
          textString="%name"),
          Polygon(
            points={{-60,6},{-60,4},{54,4},{54,4},{18,14},{18,6},{-60,6}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{54,-8},{54,-6},{-60,-6},{-60,-6},{-24,-16},{-24,-8},{54,-8}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid)}),
      Documentation(revisions="<html>
<p><i>2013-2020 by </i>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>",   info="<html>
<p><b>s<sub>1</sub>&middot;S<sub>1</sub> + .. + s<sub>nS</sub>&middot;S<sub>nS</sub> &lt;-&gt; p<sub>1</sub>&middot;P<sub>1</sub> + .. + p<sub>nP</sub>&middot;P<sub>nP</sub></b> </p>
<p>By redefinition of stoichometry as v<sub>i</sub> = -s<sub>i</sub>, A<sub>i</sub> = S<sub>i</sub> for i=1..nS v<sub>i</sub> = p<sub>i-nS</sub>, A<sub>i</sub> = P<sub>i-nS</sub> for i=nS+1..nS+nP </p>
<p>So the reaction can be written also as 0 = &sum; (v<sub>i</sub> &middot; A<sub>i</sub>) </p>
<h4><span style=\"color:#008000\">Equilibrium equation</span></h4>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p>K = <a href=\"modelica://ModelicaReference.Operators.'product()'\">product</a>(a(S)<a href=\"modelica://ModelicaReference.Operators.ElementaryOperators\">.^</a>s) / <a href=\"modelica://ModelicaReference.Operators.'product()'\">product</a>( a(P)<a href=\"modelica://ModelicaReference.Operators.ElementaryOperators\">.^</a>s ) = <a href=\"modelica://ModelicaReference.Operators.'product()'\">product</a>(a(A)<a href=\"modelica://ModelicaReference.Operators.ElementaryOperators\">.^</a>v)&nbsp;</p></td>
<td><p>dissociation constant</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>r</sub>G = &sum; (v<sub>i</sub> &middot; &Delta;<sub>f</sub>G<sub>i</sub>) = &Delta;<sub>r</sub>H - T&middot;&Delta;<sub>r</sub>S = -R&middot;T&middot;<a href=\"modelica://ModelicaReference.Operators.'log()'\">log</a>(K) </p></td>
<td><p>molar Gibb&apos;s energy of the reaction</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>r</sub>H = &sum; (v<sub>i</sub> &middot; &Delta;<sub>f</sub>H<sub>i</sub>) </p></td>
<td><p>molar enthalpy of the reaction</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>r</sub>S = &sum; (v<sub>i</sub> &middot; &Delta;<sub>f</sub>S<sub>i</sub>) = <a href=\"modelica://Modelica.Constants\">k</a>&middot;<a href=\"modelica://ModelicaReference.Operators.'log()'\">log</a>(&Delta;<sub>r</sub>&omega;) </p></td>
<td><p>molar entropy of the reaction</p></td>
</tr>
</table>
<h4><span style=\"color:#008000\">Notations</span></h4>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p>A<sub>i</sub></p></td>
<td><p>i-th substance</p></td>
</tr>
<tr>
<td><p>v<sub>i</sub></p></td>
<td><p>stochiometric coefficients of i-th substance</p></td>
</tr>
<tr>
<td><p>K</p></td>
<td><p>dissociation constant (activity based)</p></td>
</tr>
<tr>
<td><p>a(A<sub>i</sub>)=f<sub>i</sub>*x<sub>i</sub></p></td>
<td><p>activity of the substance A</p></td>
</tr>
<tr>
<td><p>f<sub>i</sub></p></td>
<td><p>activity coefficient of the substance A</p></td>
</tr>
<tr>
<td><p>x<sub>i</sub></p></td>
<td><p>mole fraction of the substance A</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>f</sub>H<sub>i</sub></p></td>
<td><p>molar enthalpy of formation of i-th substance</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>f</sub>G<sub>i</sub></p></td>
<td><p>molar Gibbs energy of formation of i-th substance</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>f</sub>S<sub>i</sub></p></td>
<td><p>molar entropy of formation of i-th substance</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>r</sub>&omega;</p></td>
<td><p>change of number of microstates of particles by reaction</p></td>
</tr>
<tr>
<td></td>
<td></td>
</tr>
</table>
</html>"));
  end Reaction;
  extends Modelica.Icons.Package;

  model Diffusion "Solute diffusion"
    extends Icons.Diffusion;
    extends Chemical.Interfaces.SISO;
    extends Chemical.Interfaces.PartialSolutionSensor(solutionFrom = SolutionChoice.Parameter);
    extends Chemical.Interfaces.ConditionalKinetics
                                          (k_forward=1);

    import Chemical.Utilities.Types.SolutionChoice;



    replaceable function uLoss =
        Chemical.Processes.Internal.Kinetics.generalPotentialLoss
      constrainedby
        Internal.Kinetics.partialPotentialLoss "Electro-chemical potential loss function"
      annotation(choicesAllMatching=true, Documentation(info="<html>
    <p>Electro-chemical potential loss function used in the diffusion.</p>
    </html>"));

  equation
    fore.definition = rear.definition;
    fore.solution = solutionState;

    connect(rear.solution,inputSubstrateSolution);


    du_rear = -uLoss(n_flow,kf,x_fore,rear.solution);
    du_fore = -uLoss(-n_flow,kf,x_rear,fore.solution);

     annotation ( Documentation(revisions="<html>
<p><i>2009-2015 by </i>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>",   info="<html>
<p>Diffusion of the substance as equilibration of electro-chemical potentials.</p>
</html>"));
  end Diffusion;

  model GasSolubility "Henry's law of gas solubility into liquid."
    extends Icons.GasSolubility;
  //  extends Interfaces.PartialGasToLiquid;
  //  extends Interfaces.ConditionalKinetics(k_forward=1);

    extends Chemical.Interfaces.SISO;
    extends Chemical.Interfaces.PartialSolutionSensor(solutionFrom = SolutionChoice.Parameter);
    extends Chemical.Interfaces.ConditionalKinetics(k_forward=1);

    import Chemical.Utilities.Types.SolutionChoice;
    import Chemical.Utilities.Types.FirstProductChoice;

    parameter FirstProductChoice productFrom=Chemical.Utilities.Types.FirstProductChoice.Process "Choice of products definition"
      annotation (HideResult=true, Dialog(group="Conditional inputs"));

    parameter Chemical.Interfaces.Definition product = Chemical.Substances.Liquid.Unknown "Product definitions"
      annotation (choicesAllMatching=true, Dialog(group="Process definition", enable=(productFrom ==FirstProductChoice.fromParameter)));

     parameter Chemical.Interfaces.Definition process = Chemical.Interfaces.processData(           K,dH,dCp,dVs)
     "Process changes of Gibbs energy, enthalpy, volume and heat capacity (products - reactants)"
        annotation (Dialog(group="Process definition",
        enable=(productFrom ==FirstProductChoice.fromProcessEnergies)));

    parameter Real K=1 "Process dissociation constant at 25°C,1bar"
     annotation (HideResult=true, Dialog(group="Process definition",enable=(productFrom ==FirstProductChoice.fromProcessParameters)));

    parameter Modelica.Units.SI.MolarEnergy dH=0 "Process molar enthalpy change at 25°C,1bar"
     annotation (HideResult=true,Dialog(group="Process definition",enable=(productFrom ==FirstProductChoice.fromProcessParameters)));

    parameter Modelica.Units.SI.MolarHeatCapacity dCp=0 "Process molar heat capacity change at 25°C,1bar"
     annotation (HideResult=true,Dialog(group="Process definition",enable=(productFrom ==FirstProductChoice.fromProcessParameters)));

    parameter Modelica.Units.SI.SpecificVolume dVs=0 "Process specific volume change at 25°C,1bar [L/g]"
     annotation (HideResult=true,Dialog(group="Process definition",enable=(productFrom ==FirstProductChoice.fromProcessParameters)));

    replaceable function uLoss =
        Chemical.Processes.Internal.Kinetics.generalPotentialLoss
      constrainedby
        Internal.Kinetics.partialPotentialLoss "Electro-chemical potential loss function"
      annotation(choicesAllMatching=true, Documentation(info="<html>
    <p>Electro-chemical potential loss function used in the diffusion.</p>
    </html>"));

  equation

    if (productFrom ==FirstProductChoice.Substance)  then
      fore.definition.data = product.data;
    else
      fore.definition = rear.definition + process;
    end if;

    fore.solution = solutionState;
    connect(rear.solution,inputSubstrateSolution);

    du_rear = -uLoss(n_flow,kf,x_fore,rear.solution);
    du_fore = -uLoss(-n_flow,kf,x_rear,fore.solution);

    annotation (
     Documentation(revisions="<html>
<p><i>2009-2015 </i></p>
<p><i>by </i>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>",   info="<html>
<p>Gaseuous substance dissolition in liquid (Henry&apos;s law, Raoult&apos;s law, Nernst dissolution in one). </p>
<h4><span style=\"color:#008000\">Equilibrium equation</span></h4>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p>K<sub>H</sub> =x<sub>L</sub> / x<sub>g</sub>&nbsp;</p></td>
<td><p>Henry&apos;s coefficient, Raoult&apos;s coefficient</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>sol</sub>G = &Delta;<sub>f</sub>G<sub>L </sub>- &Delta;<sub>f</sub>G<sub>g </sub>= &Delta;<sub>sol</sub>H - T&middot;&Delta;<sub>sol</sub>S = -R&middot;T&middot;<a href=\"modelica://ModelicaReference.Operators.'log()'\">log</a>(K<sub>H</sub>&middot; (f<sub>L</sub> / f<sub>g</sub>)) </p></td>
<td><p>molar Gibb&apos;s energy of the dissolition</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>sol</sub>H = &Delta;<sub>f</sub>H<sub>L </sub>- &Delta;<sub>f</sub>H<sub>g</sub></p></td>
<td><p>molar enthalpy of the dissolition</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>sol</sub>S = &Delta;<sub>f</sub>S<sub>L</sub> - &Delta;<sub>f</sub>S<sub>g</sub> = <a href=\"modelica://Modelica.Constants\">k</a>&middot;<a href=\"modelica://ModelicaReference.Operators.'log()'\">log</a>(&Delta;<sub>sol</sub>&omega;) </p></td>
<td><p>molar entropy of the dissolition</p></td>
</tr>
</table>
<h4><span style=\"color:#008000\">Notations</span></h4>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p>x<sub>L</sub></p></td>
<td><p>mole fraction of the substance in the liquid</p></td>
</tr>
<tr>
<td><p>x<sub>g</sub></p></td>
<td><p>mole fraction of the substance in the gas</p></td>
</tr>
<tr>
<td><p>f<sub>L</sub></p></td>
<td><p>activity coefficient of the substance in the liquid</p></td>
</tr>
<tr>
<td><p>f<sub>g</sub></p></td>
<td><p>activity coefficient of the substance in the gas</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>f</sub>H<sub>L</sub></p></td>
<td><p>molar enthalpy of formation of the substance in the liquid</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>f</sub>H<sub>g</sub></p></td>
<td><p>molar enthalpy of formation of the substance in the gas</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>f</sub>S<sub>L</sub></p></td>
<td><p>molar entropy of formation of the substance in the liquid</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>f</sub>S<sub>g</sub></p></td>
<td><p>molar entropy of formation of the substance in the gas</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>sol</sub>G</p></td>
<td><p>molar Gibbs energy of dissolvation of the substance in the liquid</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>sol</sub>&omega;</p></td>
<td><p>change of number of microstates of particles by dissolution</p></td>
</tr>
<tr>
<td></td>
<td></td>
</tr>
</table>
</html>"));
  end GasSolubility;

  model Membrane "Passive transport of the substance through semipermeable membrane"
    extends Icons.Membrane;

    extends Chemical.Interfaces.SISO;
    extends Chemical.Interfaces.PartialSolutionSensor(solutionFrom = SolutionChoice.Parameter);
    extends Chemical.Interfaces.ConditionalKinetics
                                          (k_forward=1);

    import Chemical.Utilities.Types.SolutionChoice;



    replaceable function uLoss =
        Chemical.Processes.Internal.Kinetics.generalPotentialLoss
      constrainedby
        Internal.Kinetics.partialPotentialLoss "Electro-chemical potential loss function"
      annotation(choicesAllMatching=true, Documentation(info="<html>
    <p>Electro-chemical potential loss function used in the diffusion.</p>
    </html>"));

  equation
    fore.definition = rear.definition;
    fore.solution = solutionState;

    connect(rear.solution,inputSubstrateSolution);


    du_rear = -uLoss(n_flow,kf,x_fore,rear.solution);
    du_fore = -uLoss(-n_flow,kf,x_rear,fore.solution);

    annotation ( Documentation(info="<html>
<p><u><b><font style=\"color: #008000; \">Filtration throught semipermeable membrane.</font></b></u></p>
<p>The penetrating particles are driven by electric and chemical gradient to reach Donnan&apos;s equilibrium.</p>
<p>If zero-flow Donnan&apos;s equilibrium is reached. </p>
</html>",
        revisions="<html>
<p><i>2015 by </i>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"),
         Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
          Text(
            extent={{-97,-12},{97,12}},
            textString="%name",
            lineColor={128,0,255},
          origin={69,2},
          rotation=90)}));
  end Membrane;

  model Pump "Prescribed sunstance molar flow"
    extends Chemical.Interfaces.SISO;
    extends Chemical.Interfaces.PartialSolutionSensor(solutionFrom = SolutionChoice.Parameter);
    extends Interfaces.ConditionalSubstanceFlow;

    import Chemical.Utilities.Types.SolutionChoice;


  equation
    fore.definition = rear.definition;
    fore.solution = solutionState;

    connect(rear.solution,inputSubstrateSolution);


    du_rear=-du_fore;
    n_flow = q;

   annotation (
      Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{
              100,100}}), graphics={
          Rectangle(
            extent={{-100,-50},{100,50}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            rotation=360),
          Polygon(
            points={{-80,25},{80,0},{-80,-25},{-80,25}},
            lineColor={0,0,127},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            rotation=360),
          Text(
            extent={{-150,-20},{150,20}},
            lineColor={128,0,255},
            origin={0,-72},
            rotation=360,
            textString="%name")}),        Documentation(revisions="<html>
<p><i>2009-2015</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"));
  end Pump;

  model ForwardReaction "Chemical Reaction"
    extends Chemical.Processes.Internal.PartialReactionWithProductsDefinition(final process, final firstProductFrom=Chemical.Utilities.Types.FirstProductChoice.Substance);
    extends Chemical.Interfaces.PartialSolutionSensor(solutionFrom = if nS==0 then SolutionChoice.Parameter else SolutionChoice.FirstSubstrate);
    extends Chemical.Interfaces.ConditionalKinetics(k_forward=1);


    import Chemical.Utilities.Types.SolutionChoice;


  equation

    rr = kf*Sx_fore;

    if (nS>0) then
      du_fore = -du_rear;
    end if;

    //chemical solution and its propagation
    connect(substrates[1].solution,inputSubstrateSolution);
    if nS>0 then
      products.solution = fill(solutionState,nP);
    end if;

    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{
            100,100}}),   graphics={
          Rectangle(
            extent={{-100,-30},{100,30}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,-72},{100,-40}},
            lineColor={128,0,255},
          textString="%name"),
          Polygon(
            points={{-60,2},{-60,0},{54,0},{54,0},{18,10},{18,2},{-60,2}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-60,-2},{-60,0},{54,0},{54,0},{18,-10},{18,-2},{-60,-2}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid)}),
      Documentation(revisions="<html>
<p><i>2013-2020 by </i>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>",   info="<html>
<p><b>s<sub>1</sub>&middot;S<sub>1</sub> + .. + s<sub>nS</sub>&middot;S<sub>nS</sub> &lt;-&gt; p<sub>1</sub>&middot;P<sub>1</sub> + .. + p<sub>nP</sub>&middot;P<sub>nP</sub></b> </p>
<p>By redefinition of stoichometry as v<sub>i</sub> = -s<sub>i</sub>, A<sub>i</sub> = S<sub>i</sub> for i=1..nS v<sub>i</sub> = p<sub>i-nS</sub>, A<sub>i</sub> = P<sub>i-nS</sub> for i=nS+1..nS+nP </p>
<p>So the reaction can be written also as 0 = &sum; (v<sub>i</sub> &middot; A<sub>i</sub>) </p>
<h4><span style=\"color:#008000\">Equilibrium equation</span></h4>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p>K = <a href=\"modelica://ModelicaReference.Operators.'product()'\">product</a>(a(S)<a href=\"modelica://ModelicaReference.Operators.ElementaryOperators\">.^</a>s) / <a href=\"modelica://ModelicaReference.Operators.'product()'\">product</a>( a(P)<a href=\"modelica://ModelicaReference.Operators.ElementaryOperators\">.^</a>s ) = <a href=\"modelica://ModelicaReference.Operators.'product()'\">product</a>(a(A)<a href=\"modelica://ModelicaReference.Operators.ElementaryOperators\">.^</a>v)&nbsp;</p></td>
<td><p>dissociation constant</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>r</sub>G = &sum; (v<sub>i</sub> &middot; &Delta;<sub>f</sub>G<sub>i</sub>) = &Delta;<sub>r</sub>H - T&middot;&Delta;<sub>r</sub>S = -R&middot;T&middot;<a href=\"modelica://ModelicaReference.Operators.'log()'\">log</a>(K) </p></td>
<td><p>molar Gibb&apos;s energy of the reaction</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>r</sub>H = &sum; (v<sub>i</sub> &middot; &Delta;<sub>f</sub>H<sub>i</sub>) </p></td>
<td><p>molar enthalpy of the reaction</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>r</sub>S = &sum; (v<sub>i</sub> &middot; &Delta;<sub>f</sub>S<sub>i</sub>) = <a href=\"modelica://Modelica.Constants\">k</a>&middot;<a href=\"modelica://ModelicaReference.Operators.'log()'\">log</a>(&Delta;<sub>r</sub>&omega;) </p></td>
<td><p>molar entropy of the reaction</p></td>
</tr>
</table>
<h4><span style=\"color:#008000\">Notations</span></h4>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p>A<sub>i</sub></p></td>
<td><p>i-th substance</p></td>
</tr>
<tr>
<td><p>v<sub>i</sub></p></td>
<td><p>stochiometric coefficients of i-th substance</p></td>
</tr>
<tr>
<td><p>K</p></td>
<td><p>dissociation constant (activity based)</p></td>
</tr>
<tr>
<td><p>a(A<sub>i</sub>)=f<sub>i</sub>*x<sub>i</sub></p></td>
<td><p>activity of the substance A</p></td>
</tr>
<tr>
<td><p>f<sub>i</sub></p></td>
<td><p>activity coefficient of the substance A</p></td>
</tr>
<tr>
<td><p>x<sub>i</sub></p></td>
<td><p>mole fraction of the substance A</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>f</sub>H<sub>i</sub></p></td>
<td><p>molar enthalpy of formation of i-th substance</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>f</sub>G<sub>i</sub></p></td>
<td><p>molar Gibbs energy of formation of i-th substance</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>f</sub>S<sub>i</sub></p></td>
<td><p>molar entropy of formation of i-th substance</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>r</sub>&omega;</p></td>
<td><p>change of number of microstates of particles by reaction</p></td>
</tr>
<tr>
<td></td>
<td></td>
</tr>
</table>
</html>"));
  end ForwardReaction;

  model Stream "Flow of whole solution"
    extends Chemical.Interfaces.SISO;
    extends Chemical.Interfaces.PartialSolutionSensor(solutionFrom = SolutionChoice.Parameter);
    extends Boundaries.Internal.ConditionalSolutionFlow;

    import Chemical.Utilities.Types.SolutionChoice;


  equation
    fore.definition = rear.definition;
    fore.solution = solutionState;

    connect(rear.solution,inputSubstrateSolution);


    du_rear=-du_fore;
    n_flow = x_rear * (solutionState.n/solutionState.V) * volumeFlow;


   annotation (
      Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
                          graphics={
          Rectangle(
            extent={{-100,-50},{100,50}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            rotation=360),
          Polygon(
            points={{-80,25},{80,0},{-80,-25},{-80,25}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            rotation=360),
          Text(
            extent={{-150,-20},{150,20}},
            textString="%name",
            lineColor={128,0,255},
            origin={2,-74},
            rotation=180)}),
      Documentation(revisions="<html>
<p><i>2009-2018 by </i>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>",   info="<html>
<h4><font color=\"#008000\">Bidirectional mass flow by concentration</font></h4>
<p>Possible field values: </p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0.1\"><tr>
<td></td>
<td><h4>forward flow</h4></td>
<td><h4>backward flow</h4></td>
</tr>
<tr>
<td><h4>solutionFlow</h4></td>
<td><p align=\"center\">&gt;=0</p></td>
<td><p align=\"center\">&lt;=0</p></td>
</tr>
<tr>
<td><h4>q_in.q</h4></td>
<td><p align=\"center\">=solutionFlow*q_in.conc</p></td>
<td><p align=\"center\">=-q_out.q</p></td>
</tr>
<tr>
<td><h4>q_out.q</h4></td>
<td><p align=\"center\">=-q_in.q</p></td>
<td><p align=\"center\">=solutionFlow*q_out.conc</p></td>
</tr>
</table>
<br/>
</html>"));
  end Stream;

  package Internal "Internals package for Processes"
    extends Modelica.Icons.InternalPackage;

    type InitializationMethodsCondElement = enumeration(
        T "Temperature T_0",
        h "molar enthalpy h_0",
        fore "input state from fore",
        rear "input state from rear",
        port "regularized input state from fore or rear, depending on massflow") "Choices for initialization of state h of undirected ConductionElement"
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false)),
        Diagram(coordinateSystem(preserveAspectRatio=false)),
        Documentation(info="<html>
<u>
Choices for initialization of a state h.
</u>
</html>"));
    partial model PartialReactionWithProductsDefinition "Chemical Reaction"
      extends Chemical.Processes.Internal.PartialReaction;

      import Chemical.Substances.Liquid;
      import Chemical.Substances.Gas;
      import Chemical.Substances.Solid;
      import Chemical.Substances.Aqueous;

      import FirstProductChoice =
             Chemical.Utilities.Types.FirstProductChoice;

      parameter FirstProductChoice firstProductFrom=FirstProductChoice.Process  "First product definition comes from?"
          annotation(HideResult=true, Dialog(group="Conditional inputs"));

      parameter Chemical.Interfaces.Definition firstProduct=dropOfCommons.DefaultSubstance "First product definition"
        annotation (choicesAllMatching=true, Dialog(enable=(firstProductFrom == FirstProductChoice.Substance)));


      // for unknown reason this array can not be empty in Dymola 2025 - stupid fix: max(1,nP-1) instead of max(0,nP-1) is used as size of the array
      parameter Chemical.Interfaces.Definition nextProducts[:]=fill(dropOfCommons.DefaultSubstance, max(1,nP-1)) "Definitions of next products"
        annotation (choicesAllMatching=true, Dialog(enable=(nP > 1)));


      parameter Chemical.Interfaces.Definition process = Chemical.Interfaces.processData(1)
       "Process changes of Gibbs energy, enthalpy, volume and heat capacity (products - reactants)"
       annotation (Dialog(enable=(firstProductFrom == FirstProductChoice.Process)));

    /*
  parameter Real K=1 "Process dissociation constant at 25°C,1bar"
   annotation (HideResult=true, Dialog(group="Process definition",enable=(firstProductFrom == FirstProductChoice.ProcessProperties)));

  parameter Modelica.Units.SI.MolarEnergy dH=0 "Process molar enthalpy change at 25°C,1bar"
   annotation (HideResult=true,Dialog(group="Process definition",enable=(firstProductFrom == FirstProductChoice.ProcessProperties)));

  parameter Modelica.Units.SI.MolarHeatCapacity dCp=0 "Process molar heat capacity change at 25°C,1bar"
   annotation (HideResult=true,Dialog(group="Process definition",enable=(firstProductFrom == FirstProductChoice.ProcessProperties)));

  parameter Modelica.Units.SI.SpecificVolume dVs=0 "Process specific volume change at 25°C,1bar [L/g]"
   annotation (HideResult=true,Dialog(group="Process definition",enable=(firstProductFrom == FirstProductChoice.ProcessProperties)));
*/
    equation

      if (nP>1) then
        for i in 1:nP-1 loop
           products[i+1].definition = nextProducts[i];
        end for;
      end if;

      if (nP>0)  then

        if (firstProductFrom == FirstProductChoice.Substance)  then
          products[1].definition = firstProduct;
        elseif (nP>1) then
          for i in 1:1 loop //this stupid loop is only for disabling check error about enpty array p[:] in Dymola 2025
            products[1].definition =
              (1/p[i]) * (s*substrates.definition + process - p[2:end]*nextProducts);
          end for;

        else
          for i in 1:1 loop //this stupid loop is only for disabling check error about enpty array p[:] in Dymola 2025
            products[1].definition = (1/p[i])*(s*substrates.definition + process);
          end for;
        end if;
      end if;



      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{
              100,100}})),
        Documentation(revisions="<html>
<p><i>2013-2020 by </i>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>",     info="<html>
<p><b>s<sub>1</sub>&middot;S<sub>1</sub> + .. + s<sub>nS</sub>&middot;S<sub>nS</sub> &lt;-&gt; p<sub>1</sub>&middot;P<sub>1</sub> + .. + p<sub>nP</sub>&middot;P<sub>nP</sub></b> </p>
<p>By redefinition of stoichometry as v<sub>i</sub> = -s<sub>i</sub>, A<sub>i</sub> = S<sub>i</sub> for i=1..nS v<sub>i</sub> = p<sub>i-nS</sub>, A<sub>i</sub> = P<sub>i-nS</sub> for i=nS+1..nS+nP </p>
<p>So the reaction can be written also as 0 = &sum; (v<sub>i</sub> &middot; A<sub>i</sub>) </p>
<h4><span style=\"color:#008000\">Equilibrium equation</span></h4>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p>K = <a href=\"modelica://ModelicaReference.Operators.'product()'\">product</a>(a(S)<a href=\"modelica://ModelicaReference.Operators.ElementaryOperators\">.^</a>s) / <a href=\"modelica://ModelicaReference.Operators.'product()'\">product</a>( a(P)<a href=\"modelica://ModelicaReference.Operators.ElementaryOperators\">.^</a>s ) = <a href=\"modelica://ModelicaReference.Operators.'product()'\">product</a>(a(A)<a href=\"modelica://ModelicaReference.Operators.ElementaryOperators\">.^</a>v)&nbsp;</p></td>
<td><p>dissociation constant</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>r</sub>G = &sum; (v<sub>i</sub> &middot; &Delta;<sub>f</sub>G<sub>i</sub>) = &Delta;<sub>r</sub>H - T&middot;&Delta;<sub>r</sub>S = -R&middot;T&middot;<a href=\"modelica://ModelicaReference.Operators.'log()'\">log</a>(K) </p></td>
<td><p>molar Gibb&apos;s energy of the reaction</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>r</sub>H = &sum; (v<sub>i</sub> &middot; &Delta;<sub>f</sub>H<sub>i</sub>) </p></td>
<td><p>molar enthalpy of the reaction</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>r</sub>S = &sum; (v<sub>i</sub> &middot; &Delta;<sub>f</sub>S<sub>i</sub>) = <a href=\"modelica://Modelica.Constants\">k</a>&middot;<a href=\"modelica://ModelicaReference.Operators.'log()'\">log</a>(&Delta;<sub>r</sub>&omega;) </p></td>
<td><p>molar entropy of the reaction</p></td>
</tr>
</table>
<h4><span style=\"color:#008000\">Notations</span></h4>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p>A<sub>i</sub></p></td>
<td><p>i-th substance</p></td>
</tr>
<tr>
<td><p>v<sub>i</sub></p></td>
<td><p>stochiometric coefficients of i-th substance</p></td>
</tr>
<tr>
<td><p>K</p></td>
<td><p>dissociation constant (activity based)</p></td>
</tr>
<tr>
<td><p>a(A<sub>i</sub>)=f<sub>i</sub>*x<sub>i</sub></p></td>
<td><p>activity of the substance A</p></td>
</tr>
<tr>
<td><p>f<sub>i</sub></p></td>
<td><p>activity coefficient of the substance A</p></td>
</tr>
<tr>
<td><p>x<sub>i</sub></p></td>
<td><p>mole fraction of the substance A</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>f</sub>H<sub>i</sub></p></td>
<td><p>molar enthalpy of formation of i-th substance</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>f</sub>G<sub>i</sub></p></td>
<td><p>molar Gibbs energy of formation of i-th substance</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>f</sub>S<sub>i</sub></p></td>
<td><p>molar entropy of formation of i-th substance</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>r</sub>&omega;</p></td>
<td><p>change of number of microstates of particles by reaction</p></td>
</tr>
<tr>
<td></td>
<td></td>
</tr>
</table>
</html>"));
    end PartialReactionWithProductsDefinition;

    partial model PartialReaction "Chemical Reaction"
      import Chemical;
      import Chemical.Utilities.Types.InitializationMethods;


      parameter StateSelect n_flowStateSelect = StateSelect.default "State select for n_flow"
        annotation(HideResult=true, Dialog(tab="Advanced"));
      parameter InitializationMethods initN_flow =Chemical.Utilities.Types.InitializationMethods.none  "Initialization method for n_flow"
        annotation(HideResult=true, Dialog(tab= "Initialization", group="Molar flow"));
      parameter Modelica.Units.SI.MolarFlowRate n_flow_0 = 0 "Initial value for n_flow"
        annotation(HideResult=true, Dialog(tab= "Initialization", group="Molar flow", enable=(initN_flow == InitializationMethods.state)));
      parameter Utilities.Units.MolarFlowAcceleration n_acceleration_0 = 0 "Initial value for der(n_flow)"
        annotation(HideResult=true, Dialog(tab= "Initialization", group="Molar flow", enable=(initN_flow == InitializationMethods.derivative)));

      parameter Modelica.Units.SI.Time TC=0.1 "Time constant for electro-chemical potential adaption" annotation (HideResult=true, Dialog(tab="Advanced"));
      parameter Utilities.Units.Inertance L = dropOfCommons.L "Inertance of the flow"
        annotation(HideResult=true, Dialog(tab="Advanced"));

      parameter Integer nS=0 "Number of substrate types"
        annotation ( HideResult=true, Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));

      parameter Modelica.Units.SI.StoichiometricNumber s[nS]=ones(nS)
        "Stoichiometric reaction coefficient for substrates"
        annotation (HideResult=true);

      parameter Integer nP=0 "Number of product types"
        annotation ( HideResult=true, Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));

      parameter Modelica.Units.SI.StoichiometricNumber p[nP]=ones(nP)
        "Stoichiometric reaction coefficients for products"
        annotation (HideResult=true);

      Modelica.Units.SI.MolarFlowRate rr(stateSelect=n_flowStateSelect) "Reaction molar flow rate";

      Chemical.Interfaces.Rear substrates[nS] annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=180,
            origin={-100,0}), iconTransformation(
            extent={{10,-10},{-10,10}},
            rotation=180,
            origin={-100,0})));

      Chemical.Interfaces.Fore products[nP] annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=180,
            origin={100,0}), iconTransformation(
            extent={{10,-10},{-10,10}},
            rotation=180,
            origin={100,0})));

    protected

      Modelica.Units.SI.MolarEnthalpy h_fore_mix, h_rear_mix;

      Real duRT_fore, duRT_rear, du_fore, du_rear, dr, Sx_fore,Px_rear,Kx;

      Modelica.Units.SI.ChemicalPotential uPure_substrates[nS];
      Modelica.Units.SI.ChemicalPotential uPure_products[nP];
      outer DropOfCommons dropOfCommons;


      Real Px_fore,Sx_rear;

    initial equation
      if initN_flow == InitializationMethods.state then
        rr = n_flow_0;
      elseif initN_flow == InitializationMethods.derivative then
        der(rr) = n_acceleration_0;
      elseif initN_flow == InitializationMethods.steadyState then
        der(rr) = 0;
      end if;

    equation

      du_fore = (s * substrates.state_forwards.u) - (p * products.state_forwards.u);
      du_rear = (p * products.state_rearwards.u) - (s * substrates.state_rearwards.u);

      duRT_fore = ((s * (substrates.state_forwards.u ./ (Modelica.Constants.R*substrates.solution.T))) - (p * (products.state_forwards.u ./ (Modelica.Constants.R*products.solution.T))));
      duRT_rear = ((p * (products.state_rearwards.u ./ (Modelica.Constants.R*products.solution.T))) - (s * (substrates.state_rearwards.u ./ (Modelica.Constants.R*substrates.solution.T))));

      for i in 1:nS loop
       uPure_substrates[i] = Chemical.Interfaces.Properties.electroChemicalPotentialPure(
        substrates[i].definition,
        substrates[i].solution);
      end for;

      for i in 1:nP loop
       uPure_products[i] = Chemical.Interfaces.Properties.electroChemicalPotentialPure(
       products[i].definition,
       products[i].solution);
      end for;

      Sx_fore = exp(s * ((substrates.state_forwards.u - uPure_substrates)./(Modelica.Constants.R*substrates.solution.T)));
      Px_rear = exp((p * ((products.state_rearwards.u - uPure_products)./(Modelica.Constants.R*products.solution.T))));

      //debug
      Sx_rear = exp(s * ((substrates.state_rearwards.u - uPure_substrates)./(Modelica.Constants.R*substrates.solution.T)));
      Px_fore = exp((p * ((products.state_forwards.u - uPure_products)./(Modelica.Constants.R*products.solution.T))));
      Kx = exp(- ((s * ((uPure_substrates)./(Modelica.Constants.R*substrates.solution.T))) - (p * ((uPure_products)./(Modelica.Constants.R*products.solution.T)))));

      //reaction molar rates
      rr*s = substrates.n_flow;
      rr*p = -products.n_flow;

      products.state_forwards.h = h_fore_mix*ones(nP);
      substrates.state_rearwards.h = h_rear_mix*ones(nS);

      if nS>0 then
        h_rear_mix*(substrates.n_flow*ones(nS)) + products.n_flow*products.state_rearwards.h = 0;
      else
        h_rear_mix = 0;
      end if;

      if nP>0 then
        h_fore_mix*(products.n_flow*ones(nP)) + substrates.n_flow*substrates.state_forwards.h = 0;
      else
        h_fore_mix = 0;
      end if;

      dr = (s * substrates.r) - (p * products.r);

      if nP>0 then

        (p * products.r) = (s * substrates.r)  -  der(rr)*L;

        for i in 2:nP loop
          //first product is based on inertial potential,
          //other products are provided as source with fixed flow and adaptation of their potential
          der(products[i].state_forwards.u).*TC = products[i].r;
        end for;
        for i in 2:nS loop
          der(substrates[i].state_rearwards.u).*TC = substrates[i].r;
        end for;
      end if;

      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{
              100,100}})),
        Documentation(revisions="<html>
<p><i>2013-2025 by </i>Marek Mateják </p>
</html>",     info="<html>
<h4><span style=\"color: #008000\">Notations</span></h4>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p>A<sub>i</sub></p></td>
<td><p>i-th substance</p></td>
</tr>
<tr>
<td><p>v<sub>i</sub></p></td>
<td><p>stochiometric coefficients of i-th substance</p></td>
</tr>
<tr>
<td><p>K</p></td>
<td><p>dissociation constant (activity based)</p></td>
</tr>
<tr>
<td><p>a(A<sub>i</sub>)=f<sub>i</sub>*x<sub>i</sub></p></td>
<td><p>activity of the substance A</p></td>
</tr>
<tr>
<td><p>f<sub>i</sub></p></td>
<td><p>activity coefficient of the substance A</p></td>
</tr>
<tr>
<td><p>x<sub>i</sub></p></td>
<td><p>mole fraction of the substance A</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>f</sub>H<sub>i</sub></p></td>
<td><p>molar enthalpy of formation of i-th substance</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>f</sub>G<sub>i</sub></p></td>
<td><p>molar Gibbs energy of formation of i-th substance</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>f</sub>S<sub>i</sub></p></td>
<td><p>molar entropy of formation of i-th substance</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>r</sub>&omega;</p></td>
<td><p>change of number of microstates of particles by reaction</p></td>
</tr>
<tr>
<td></td>
<td></td>
</tr>
</table>
</html>"));
    end PartialReaction;

    partial model PartialSwitchSolution "Substance between different chemical solutions"
      extends Chemical.Interfaces.SISO;

      Interfaces.SolutionPort solution annotation (Placement(transformation(extent={{92,-52},{112,-32}}),   iconTransformation(extent={{92,-52},{112,-32}})));

    equation

      fore.definition = rear.definition;

      fore.solution.T = solution.T;
      fore.solution.p = solution.p;
      fore.solution.v = solution.v;
      fore.solution.n = solution.n;
      fore.solution.m = solution.m;
      fore.solution.V = solution.V;
      fore.solution.G = solution.G;
      fore.solution.Q = solution.Q;
      fore.solution.I = solution.I;

      solution.dH = 0;
      solution.i = 0;
      solution.Qj = 0;
      solution.Ij = 0;
      solution.nj = 0;
      solution.mj = 0;
      solution.Vj = 0;
      solution.Gj = 0;
      solution.dV = 0;

      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{
              100,100}})),
        Documentation(revisions="<html>
<p><i>2013-2020 by </i>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>",     info="<html>
<p><b>s<sub>1</sub>&middot;S<sub>1</sub> + .. + s<sub>nS</sub>&middot;S<sub>nS</sub> &lt;-&gt; p<sub>1</sub>&middot;P<sub>1</sub> + .. + p<sub>nP</sub>&middot;P<sub>nP</sub></b> </p>
<p>By redefinition of stoichometry as v<sub>i</sub> = -s<sub>i</sub>, A<sub>i</sub> = S<sub>i</sub> for i=1..nS v<sub>i</sub> = p<sub>i-nS</sub>, A<sub>i</sub> = P<sub>i-nS</sub> for i=nS+1..nS+nP </p>
<p>So the reaction can be written also as 0 = &sum; (v<sub>i</sub> &middot; A<sub>i</sub>) </p>
<h4><span style=\"color:#008000\">Equilibrium equation</span></h4>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p>K = <a href=\"modelica://ModelicaReference.Operators.'product()'\">product</a>(a(S)<a href=\"modelica://ModelicaReference.Operators.ElementaryOperators\">.^</a>s) / <a href=\"modelica://ModelicaReference.Operators.'product()'\">product</a>( a(P)<a href=\"modelica://ModelicaReference.Operators.ElementaryOperators\">.^</a>s ) = <a href=\"modelica://ModelicaReference.Operators.'product()'\">product</a>(a(A)<a href=\"modelica://ModelicaReference.Operators.ElementaryOperators\">.^</a>v)&nbsp;</p></td>
<td><p>dissociation constant</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>r</sub>G = &sum; (v<sub>i</sub> &middot; &Delta;<sub>f</sub>G<sub>i</sub>) = &Delta;<sub>r</sub>H - T&middot;&Delta;<sub>r</sub>S = -R&middot;T&middot;<a href=\"modelica://ModelicaReference.Operators.'log()'\">log</a>(K) </p></td>
<td><p>molar Gibb&apos;s energy of the reaction</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>r</sub>H = &sum; (v<sub>i</sub> &middot; &Delta;<sub>f</sub>H<sub>i</sub>) </p></td>
<td><p>molar enthalpy of the reaction</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>r</sub>S = &sum; (v<sub>i</sub> &middot; &Delta;<sub>f</sub>S<sub>i</sub>) = <a href=\"modelica://Modelica.Constants\">k</a>&middot;<a href=\"modelica://ModelicaReference.Operators.'log()'\">log</a>(&Delta;<sub>r</sub>&omega;) </p></td>
<td><p>molar entropy of the reaction</p></td>
</tr>
</table>
<h4><span style=\"color:#008000\">Notations</span></h4>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p>A<sub>i</sub></p></td>
<td><p>i-th substance</p></td>
</tr>
<tr>
<td><p>v<sub>i</sub></p></td>
<td><p>stochiometric coefficients of i-th substance</p></td>
</tr>
<tr>
<td><p>K</p></td>
<td><p>dissociation constant (activity based)</p></td>
</tr>
<tr>
<td><p>a(A<sub>i</sub>)=f<sub>i</sub>*x<sub>i</sub></p></td>
<td><p>activity of the substance A</p></td>
</tr>
<tr>
<td><p>f<sub>i</sub></p></td>
<td><p>activity coefficient of the substance A</p></td>
</tr>
<tr>
<td><p>x<sub>i</sub></p></td>
<td><p>mole fraction of the substance A</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>f</sub>H<sub>i</sub></p></td>
<td><p>molar enthalpy of formation of i-th substance</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>f</sub>G<sub>i</sub></p></td>
<td><p>molar Gibbs energy of formation of i-th substance</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>f</sub>S<sub>i</sub></p></td>
<td><p>molar entropy of formation of i-th substance</p></td>
</tr>
<tr>
<td><p>&Delta;<sub>r</sub>&omega;</p></td>
<td><p>change of number of microstates of particles by reaction</p></td>
</tr>
<tr>
<td></td>
<td></td>
</tr>
</table>
</html>"));
    end PartialSwitchSolution;

    package Kinetics

      partial function partialPotentialLoss "Interface for potential loss functions"
        extends Modelica.Icons.Function;

        input Modelica.Units.SI.MolarFlowRate n_flow "Molar flow rate";
        input Real kf "Forward rate coefficient";
        input Modelica.Units.SI.MoleFraction x "Substrates mole fraction product";
        input Chemical.Interfaces.SolutionState solutionState "Solution state";

        output Modelica.Units.SI.ChemicalPotential potentialLoss "Gibbs energy lost in chemical process";

        annotation(Inline=true, smoothOrder=100,
          Documentation(info="<html>
    <p>Interface definition for a potential loss in a chemical process. Inputs are information about flow condition and the chemical solution state, output is the electro-chemical potential drop.</p>
</html>"));
      end partialPotentialLoss;

      function generalPotentialLoss "General potential loss function trough forward/backward rate coefficient"
        extends partialPotentialLoss;

       // input Real kf(unit="Pa.s/kg") = 1 "Forward rate coeeficient"
      algorithm
        potentialLoss := Modelica.Constants.R*solutionState.T*log(1-n_flow/(kf*x));
          annotation(Dialog(enable=true),
                    Documentation(info="<html>
<p>
This Gibbs energy loss du to reach chemical process molar flow q: 
</p>
<blockquote><pre>
 = kf * xA - kb * xB
</pre></blockquote>
<p>
where kf is the forwar rate coefficient and kb is backward rate coefficient of chemical process;
xA is mole fraction os substrate and xB is mole fraction of product.
And K = kf/kb = xB/xA is a dissociation coefficient of the chemical process.
</p>
</html>"));

      end generalPotentialLoss;

      function fastPotentialLoss "Fast potential loss function"
        extends partialPotentialLoss;

        input Real kC(unit="mol2/(J.s)") = 1 "Linear factor"
          annotation(Dialog(enable=true));


      algorithm
        potentialLoss := n_flow/kC;

        annotation (Documentation(info="<html>
<p>
This Gibbs energy loss is linear in the molarflow with the linear factor kC: 
</p>
<blockquote><pre>
du := n_flow/kC;
</pre></blockquote>
</html>"));
      end fastPotentialLoss;
    end Kinetics;
  end Internal;

  package Tests "Tests for top level components of undirected"
    extends Modelica.Icons.ExamplesPackage;

    model TestFlow "Test for the undirected flow resistance"
      extends Modelica.Icons.Example;

      Chemical.Boundaries.BoundaryRear boundary_rear(u0_par=100000)
        annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=180,
            origin={-30,0})));
      Chemical.Boundaries.BoundaryFore boundary_fore(potentialFromInput=true, u0_par=110000) annotation (Placement(transformation(extent={{20,-10},{40,10}})));
      inner Chemical.DropOfCommons dropOfCommons(n_flow_reg=0.01) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
      Modelica.Blocks.Sources.Step step(
        height=-80000,
        offset=140000,
        startTime=5)
        annotation (Placement(transformation(extent={{60,-6},{48,6}})));
      Chemical.Boundaries.BoundaryRear boundary_rear1(potentialFromInput=true)
        annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=180,
            origin={-28,-38})));
      Chemical.Boundaries.BoundaryFore boundary_fore1(potentialFromInput=false, u0_par=100000)
        annotation (Placement(transformation(extent={{22,-48},{42,-28}})));
      Reaction reaction(
        firstProductFrom=Chemical.Utilities.Types.FirstProductChoice.Substance,
        nS=1,
        nP=1) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
      Reaction reaction1(
        firstProductFrom=Chemical.Utilities.Types.FirstProductChoice.Substance,
        nS=1,
        nP=1) annotation (Placement(transformation(extent={{-8,-48},{12,-28}})));
    equation
      connect(step.y, boundary_fore.u0_var)
        annotation (Line(points={{47.4,0},{40,0},{40,6},{32,6}},
                                                       color={0,0,127}));
      connect(boundary_rear1.u0_var, boundary_fore.u0_var)
        annotation (Line(points={{-30,-44},{-40,-44},{-40,-20},{40,-20},{40,6},{32,6}}, color={0,0,127}));
      connect(boundary_rear.fore, reaction.substrates[1]) annotation (Line(
          points={{-20,0},{-10,0}},
          color={158,66,200},
          thickness=0.5));
      connect(reaction.products[1], boundary_fore.rear) annotation (Line(
          points={{10,0},{20,0}},
          color={158,66,200},
          thickness=0.5));
      connect(boundary_rear1.fore, reaction1.substrates[1]) annotation (Line(
          points={{-18,-38},{-8,-38}},
          color={158,66,200},
          thickness=0.5));
      connect(reaction1.products[1], boundary_fore1.rear) annotation (Line(
          points={{12,-38},{22,-38}},
          color={158,66,200},
          thickness=0.5));
      annotation (
        Icon(graphics,
             coordinateSystem(preserveAspectRatio=false)),
        Diagram(coordinateSystem(preserveAspectRatio=false)),
        experiment(StopTime=10, Tolerance=1e-6, Interval=0.01),
        Documentation(info="<html>
<u>Test for the undirected flow resistance.</u>
<u><br>Owner: <a href=\"mailto:michael.meissner@dlr.de\">Michael Mei&szlig;ner</a></u>
</html>"));
    end TestFlow;

    model Diffusion

      extends Modelica.Icons.Example;

      Chemical.Boundaries.Substance s2(useFore=true, mass_start=0.6) annotation (Placement(transformation(extent={{-174,20},{-154,40}})));
      Chemical.Boundaries.Substance p2(useRear=true, mass_start=0.4) annotation (Placement(transformation(extent={{-66,20},{-46,40}})));
      Chemical.Processes.Diffusion d2(solutionFrom=Chemical.Utilities.Types.SolutionChoice.FirstSubstrate, redeclare function uLoss =
            Chemical.Processes.Internal.Kinetics.generalPotentialLoss) annotation (Placement(transformation(extent={{-118,20},{-98,40}})));
      Chemical.Boundaries.Substance s1(useFore=true, mass_start=0.6) annotation (Placement(transformation(extent={{-174,58},{-154,78}})));
      Chemical.Boundaries.Substance p1(useRear=true, mass_start=0.4) annotation (Placement(transformation(extent={{-66,58},{-46,78}})));
      Chemical.Processes.Diffusion d1(solutionFrom=Chemical.Utilities.Types.SolutionChoice.Parameter, redeclare function uLoss =
            Internal.Kinetics.generalPotentialLoss) annotation (Placement(transformation(extent={{-118,58},{-98,78}})));
      Chemical.Boundaries.Substance s3(
        useFore=true,
        useSolution=true,
        mass_start=0.6) annotation (Placement(transformation(extent={{-170,-54},{-150,-34}})));
      Chemical.Boundaries.Substance p3(
        useRear=true,
        useSolution=true,
        mass_start=0.4) annotation (Placement(transformation(extent={{-62,-54},{-42,-34}})));
      Chemical.Processes.Diffusion d3(solutionFrom=Chemical.Utilities.Types.SolutionChoice.SolutionPort, redeclare function uLoss =
            Internal.Kinetics.generalPotentialLoss) annotation (Placement(transformation(extent={{-114,-56},{-94,-36}})));
      Solution solution annotation (Placement(transformation(extent={{-222,-122},{-14,-12}})));
      inner Modelica.Fluid.System system annotation (Placement(transformation(extent={{-210,64},{-190,84}})));
      Chemical.Boundaries.Substance s4(
        useFore=true,
        useSolution=false,
        mass_start=0.6) annotation (Placement(transformation(extent={{78,64},{98,84}})));
      Chemical.Boundaries.Substance p4(
        useRear=true,
        useSolution=false,
        mass_start=0.4) annotation (Placement(transformation(extent={{186,64},{206,84}})));
      Chemical.Processes.Diffusion d4(solutionFrom=Chemical.Utilities.Types.SolutionChoice.SolutionPort, redeclare function uLoss =
            Internal.Kinetics.generalPotentialLoss) annotation (Placement(transformation(extent={{134,62},{154,82}})));
      Solution solution1 annotation (Placement(transformation(extent={{26,-4},{234,106}})));
      Chemical.Boundaries.Substance solvent(useFore=false, useSolution=true,
        mass_start=1)                                                        annotation (Placement(transformation(extent={{194,24},{214,44}})));
      Chemical.Boundaries.Substance s5(
        useFore=true,
        useSolution=true,
        mass_start=0.6) annotation (Placement(transformation(extent={{64,-54},{84,-34}})));
      Chemical.Boundaries.Substance p5(
        useRear=true,
        useSolution=true,
        mass_start=0.4) annotation (Placement(transformation(extent={{172,-54},{192,-34}})));
      Chemical.Processes.Diffusion d5(solutionFrom=Chemical.Utilities.Types.SolutionChoice.FirstSubstrate, redeclare function uLoss =
            Internal.Kinetics.generalPotentialLoss) annotation (Placement(transformation(extent={{120,-56},{140,-36}})));
      Solution solution2 annotation (Placement(transformation(extent={{12,-122},{220,-12}})));
    equation
      connect(s2.fore, d2.rear) annotation (Line(
          points={{-154,30},{-118,30}},
          color={158,66,200},
          thickness=0.5));
      connect(d2.fore, p2.rear) annotation (Line(
          points={{-98,30},{-66,30}},
          color={158,66,200},
          thickness=0.5));
      connect(s1.fore, d1.rear) annotation (Line(
          points={{-154,68},{-118,68}},
          color={158,66,200},
          thickness=0.5));
      connect(d1.fore, p1.rear) annotation (Line(
          points={{-98,68},{-66,68}},
          color={158,66,200},
          thickness=0.5));
      connect(s3.fore, d3.rear) annotation (Line(
          points={{-150,-44},{-122,-44},{-122,-46},{-114,-46}},
          color={158,66,200},
          thickness=0.5));
      connect(d3.fore, p3.rear) annotation (Line(
          points={{-94,-46},{-70,-46},{-70,-44},{-62,-44}},
          color={158,66,200},
          thickness=0.5));
      connect(solution.solution, d3.solution) annotation (Line(points={{-55.6,-120.9},{-55.6,-126},{-110,-126},{-110,-56}}, color={127,127,0}));
      connect(s3.solution, solution.solution) annotation (Line(points={{-166,-54},{-166,-120.9},{-55.6,-120.9}}, color={127,127,0}));
      connect(p3.solution, solution.solution) annotation (Line(points={{-58,-54},{-58,-126},{-55.6,-126},{-55.6,-120.9}}, color={127,127,0}));
      connect(s4.fore, d4.rear) annotation (Line(
          points={{98,74},{126,74},{126,72},{134,72}},
          color={158,66,200},
          thickness=0.5));
      connect(d4.fore, p4.rear) annotation (Line(
          points={{154,72},{178,72},{178,74},{186,74}},
          color={158,66,200},
          thickness=0.5));
      connect(solution1.solution, d4.solution) annotation (Line(points={{192.4,-2.9},{192.4,-8},{138,-8},{138,62}}, color={127,127,0}));
      connect(solution1.solution, solvent.solution) annotation (Line(points={{192.4,-2.9},{192.4,-10},{198,-10},{198,24}},     color={127,127,0}));
      connect(s5.fore, d5.rear) annotation (Line(
          points={{84,-44},{112,-44},{112,-46},{120,-46}},
          color={158,66,200},
          thickness=0.5));
      connect(d5.fore, p5.rear) annotation (Line(
          points={{140,-46},{164,-46},{164,-44},{172,-44}},
          color={158,66,200},
          thickness=0.5));
      connect(s5.solution, solution2.solution) annotation (Line(points={{68,-54},{68,-120.9},{178.4,-120.9}}, color={127,127,0}));
      connect(p5.solution, solution2.solution) annotation (Line(points={{176,-54},{176,-126},{178.4,-126},{178.4,-120.9}}, color={127,127,0}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-240,-140},{240,140}})), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
                -140},{240,140}})),
        experiment(StopTime=1, __Dymola_Algorithm="Dassl"));
    end Diffusion;

    model SimpleFlow
      extends Modelica.Icons.Example;
      Chemical.Boundaries.Substance substance(
        useFore=true,
        use_mass_start=false,
        amountOfSubstance_start=2)   annotation (Placement(transformation(extent={{-70,14},{-50,34}})));
      Chemical.Boundaries.Substance substance1(
        useRear=true,
        use_mass_start=false,
        amountOfSubstance_start=0.1) annotation (Placement(transformation(extent={{48,12},{68,32}})));
      inner DropOfCommons dropOfCommons annotation (Placement(transformation(extent={{-76,66},{-56,86}})));
      Pump pump(solutionFrom=Chemical.Utilities.Types.SolutionChoice.FirstSubstrate, SubstanceFlow=1)
        annotation (Placement(transformation(extent={{-14,14},{6,34}})));
    equation
      connect(substance.fore, pump.rear) annotation (Line(
          points={{-50,24},{-14,24}},
          color={158,66,200},
          thickness=0.5));
      connect(pump.fore, substance1.rear) annotation (Line(
          points={{6,24},{40,24},{40,22},{48,22}},
          color={158,66,200},
          thickness=0.5));
    end SimpleFlow;

    annotation (Documentation(info="<html>
<u>Tests for top level components of the undirected chemical simulation package.</u>
</html>"));
  end Tests;

  annotation (Documentation(info="<html>
<u>This package contains models implementing undirected versions of the processes. Here, the thermodynamic state of one or more fluid streams is changed by exchanging heat or work with the streams, or by delaying the state.</u>
</html>", revisions="<html>
<u><img src=\"modelica:/Chemical/Resources/dlr_logo.png\"/>(c) 2020-2021, DLR, Institute of System Dynamics and Control</u>
</html>"), Icon(graphics={
         Ellipse(
          extent={{-60,54},{60,-66}},
          lineColor={158,66,200},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-94,0},{94,0}},
          color={158,66,200},
          thickness=0.5),
        Ellipse(
          extent={{-64,60},{56,-60}},
          lineColor={158,66,200},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end Processes;
