package uk.ic.dice.co.ui.launcher;

import java.io.File;
import java.net.URI;
import java.util.Set;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy;
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab;
import org.eclipse.jface.dialogs.Dialog;
import org.eclipse.jface.viewers.TableViewer;
import org.eclipse.jface.viewers.TableViewerColumn;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.layout.RowLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.Text;


import org.eclipse.swt.widgets.FileDialog;

public class MainLaunchConfigTab extends AbstractLaunchConfigurationTab {

	private enum mode {RUN,STOP,PAUSE,RESUME};
	private class FormData{
		private String configurationFile;
		private mode execMode;

		protected mode getExecutionMode(){
			return execMode;
		}

		protected void setExecutionMode(mode executionMode){
			this.execMode=executionMode;
			viewer.refresh();
			setDirty(true);
			updateLaunchConfigurationDialog();

		}
		protected String getConfigurationFile() {
			return configurationFile;
		}
		protected void setConfigurationFile(String inputFile) {
			this.configurationFile = inputFile;
			viewer.refresh();
			setDirty(true);
			updateLaunchConfigurationDialog();
		}

	}

	protected Text inputFileText;
	protected FormData data = new FormData();
	protected TableViewer viewer;
	protected TableViewerColumn varViewerColumn;
	protected TableViewerColumn valueViewerColumn;


	@Override
	public void createControl(Composite parent) {		
		Composite topComposite = new Composite(parent, SWT.NONE);
		topComposite.setLayout(new GridLayout(1, true));

		GridData buttonsGridData = new GridData(SWT.CENTER, SWT.CENTER, false, false);
		buttonsGridData.widthHint = 100;

		{ // Configuration Group
			Group group = new Group(topComposite, SWT.NONE);
			group.setLayoutData(new GridData(SWT.FILL, SWT.BEGINNING, true, false));

			group.setLayout(new GridLayout(2, false));
			group.setText(Messages.MainLaunchConfigTab_configurationLabel);

			inputFileText = new Text(group, SWT.BORDER);
			inputFileText.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));
			inputFileText.setEditable(false);

			Button fileButton = new Button(group, SWT.NONE);
			fileButton.setText(Messages.MainLaunchConfigTab_browseLabel);
			fileButton.setLayoutData(buttonsGridData);

			fileButton.addSelectionListener(new SelectionAdapter() {
				@Override
				public void widgetSelected(SelectionEvent e) {
					FileDialog fd= new FileDialog(getShell());
					fd.setText("Select"); //$NON-NLS-1$
					String[] filterExt = {"*.yaml","*.*"}; //$NON-NLS-1$ //$NON-NLS-2$
					fd.setFilterExtensions(filterExt);
					String selected = fd.open();
					data.setConfigurationFile(selected); 
				}
			});
		}

		{ // Execution mode Group
			Group group = new Group(topComposite, SWT.NONE);
			group.setLayoutData(new GridData(SWT.FILL, SWT.BEGINNING, true, false));

			group.setLayout(new RowLayout(SWT.VERTICAL));
			group.setText(uk.ic.dice.co.ui.launcher.Messages.MainLaunchConfigTab_executionModeLabel);

			Button runButton = new Button(group, SWT.RADIO);
			runButton.setText("Run CO Tool");
			runButton.setSelection(true);			
			runButton.addSelectionListener(new SelectionAdapter() {
				public void widgetSelected(SelectionEvent e) {
					data.setExecutionMode(mode.RUN);
				};
			});
			
			Button stopButton = new Button(group, SWT.RADIO);
			stopButton.setText("Stop CO Tool");			
			stopButton.addSelectionListener(new SelectionAdapter() {
				public void widgetSelected(SelectionEvent e) {
					data.setExecutionMode(mode.STOP);
				};
			});
			
			Button pauseButton = new Button(group, SWT.RADIO);
			pauseButton.setText("Pause CO Tool");			
			pauseButton.addSelectionListener(new SelectionAdapter() {
				public void widgetSelected(SelectionEvent e) {
					data.setExecutionMode(mode.PAUSE);
				};
			});
			
			Button resumeButton = new Button(group, SWT.RADIO);
			resumeButton.setText("Resume CO Tool");			
			resumeButton.addSelectionListener(new SelectionAdapter() {
				public void widgetSelected(SelectionEvent e) {
					data.setExecutionMode(mode.RESUME);
				};
			});

		}

		setControl(topComposite);

	}

	@Override
	public void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		// TODO Auto-generated method stub

	}

	@Override
	public void initializeFrom(ILaunchConfiguration configuration) {
		// TODO Auto-generated method stub

	}

	@Override
	public void performApply(ILaunchConfigurationWorkingCopy configuration) {
		// TODO Auto-generated method stub

	}

	@Override
	public String getName() {
		// TODO Auto-generated method stub
		return null;
	}

}
