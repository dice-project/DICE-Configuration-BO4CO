package uk.ic.dice.co.launcher;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.model.LaunchConfigurationDelegate;

public class COLaunchConfigurationDelegate extends LaunchConfigurationDelegate {

	public static final String INPUT_FILE = "INPUT_CONFIG"; //$NON-NLS-1$
	public static final String EXECUTION_MODE = "EXECUTION_MODE"; //$NON-NLS-1$


	@Override
	public void launch(ILaunchConfiguration configuration, String mode, ILaunch launch, IProgressMonitor monitor)
			throws CoreException {
		// TODO Auto-generated method stub

	}

}
