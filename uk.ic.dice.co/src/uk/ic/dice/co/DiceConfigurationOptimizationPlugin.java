package uk.ic.dice.co;

import org.eclipse.core.runtime.Plugin;
import org.osgi.framework.BundleContext;

public class DiceConfigurationOptimizationPlugin extends Plugin {
	public static final String PLUGIN_ID = "uk.ic.dice.co"; //$NON-NLS-1$

	public static final String SIMULATION_LAUNCH_CONFIGURATION_TYPE = "uk.ic.dice.co.ui.launchConfigurationType"; //$NON-NLS-1$

	private static DiceConfigurationOptimizationPlugin plugin;

	public DiceConfigurationOptimizationPlugin(){
		plugin=this;
	}

	@Override
	public void start(BundleContext context) throws Exception {
		super.start(context);
	}

	@Override
	public void stop(BundleContext context) throws Exception {
		// TODO Auto-generated method stub
		super.stop(context);
		plugin=null;
	}

	public DiceConfigurationOptimizationPlugin getDefault(){
		return plugin;
	}


}
