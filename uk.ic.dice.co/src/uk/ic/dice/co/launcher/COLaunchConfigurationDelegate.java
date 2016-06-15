package uk.ic.dice.co.launcher;

import java.io.File;
import java.io.IOException;
import java.text.MessageFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import javax.imageio.stream.FileImageInputStream;

import org.apache.commons.lang3.StringUtils;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.core.runtime.Status;
import org.eclipse.debug.core.DebugPlugin;
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
			
			Map<String, String> optimizationAttrs = new HashMap<>();
			optimizationAttrs.put(DebugPlugin.ATTR_LAUNCH_TIMESTAMP, Calendar.getInstance().getTime().toString());
			
			final File inputFile=getInputFile(configuration);
			
			

			
			

		} catch (Exception e) {
			// TODO: handle exception
		}


	}

	private File getInputFile(ILaunchConfiguration configuration) throws CoreException {
		String configPath = configuration.getAttribute(INPUT_FILE, StringUtils.EMPTY);
		java.net.URI inputFileUri=java.net.URI.create(configPath);
		File inputFile = new File(inputFileUri);
		if (!inputFile.isFile()){
			throw new CoreException(new Status(IStatus.ERROR, DiceConfigurationOptimizationPlugin.PLUGIN_ID, 
					MessageFormat.format("The config file does not exists or the path is invalid", inputFile)));
		}
		return inputFile;
	}
	
}
