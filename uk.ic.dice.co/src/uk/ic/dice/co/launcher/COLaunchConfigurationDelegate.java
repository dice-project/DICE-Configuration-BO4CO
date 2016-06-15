package uk.ic.dice.co.launcher;

import java.io.File;
import java.io.IOException;
import java.text.MessageFormat;

import javax.imageio.stream.FileImageInputStream;

import org.apache.commons.lang3.StringUtils;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.core.runtime.Status;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.model.LaunchConfigurationDelegate;

import uk.ic.dice.co.DiceConfigurationOptimizationPlugin;


public class COLaunchConfigurationDelegate extends LaunchConfigurationDelegate {

	public static final String INPUT_FILE = "INPUT_CONFIG"; //$NON-NLS-1$
	public static final String EXECUTION_MODE = "EXECUTION_MODE"; //$NON-NLS-1$


	@Override
	public void launch(ILaunchConfiguration configuration, String mode, ILaunch launch, IProgressMonitor monitor)
			throws CoreException {
		if (monitor == null) {
			monitor = new NullProgressMonitor();
		}
		try {
			monitor.beginTask("Configuration Optimization", IProgressMonitor.UNKNOWN);


		} catch (Exception e) {
			// TODO: handle exception
		}


	}

	private File getCOConfig(ILaunchConfiguration configuration) throws CoreException {
		String configPath = configuration.getAttribute(INPUT_FILE, StringUtils.EMPTY);
		try {
			File file = new File(configPath);
			return file;
		} catch (NullPointerException e) {
			throw new CoreException(new Status(IStatus.ERROR, DiceConfigurationOptimizationPlugin.PLUGIN_ID, 
					MessageFormat.format("The config file is empty", configPath), e));
		}
	}

}
