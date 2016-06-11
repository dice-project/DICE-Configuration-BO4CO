package uk.ic.dice.co.ui.launcher;

import org.eclipse.osgi.util.NLS;

public class Messages extends NLS {
	private static final String BUNDLE_NAME = "uk.ic.dice.co.ui.launcher.messages"; //$NON-NLS-1$
	public static String MainLaunchConfigTab_browseLabel;
	public static String MainLaunchConfigTab_configurationLabel;
	public static String MainLaunchConfigTab_executionModeLabel;
	public static String MainLaunchConfigTab_mainTabTitle;

	static {
		// initialize resource bundle
		NLS.initializeMessages(BUNDLE_NAME, Messages.class);
	}

	private Messages() {
	}
}
