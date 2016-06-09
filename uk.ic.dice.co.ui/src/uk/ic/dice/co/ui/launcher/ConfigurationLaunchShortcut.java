package uk.ic.dice.co.ui.launcher;

import org.eclipse.debug.ui.ILaunchShortcut;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.ui.IEditorPart;

public class ConfigurationLaunchShortcut implements ILaunchShortcut {

	@Override
	public void launch(ISelection selection, String mode) {
		// TODO Auto-generated method stub
		if (selection instanceof IStructuredSelection){
			IStructuredSelection structuredSelection=(IStructuredSelection) selection;
			if (!structuredSelection.isEmpty()){
				launch(structuredSelection.getFirstElement(), mode);
			}
		}


	}

	private void launch(Object firstElement, String mode) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void launch(IEditorPart editor, String mode) {
		// TODO Auto-generated method stub

	}

}
