package uk.ic.dice.co.ui.launcher;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.IAdaptable;
import org.eclipse.debug.ui.ILaunchShortcut;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.ui.IEditorInput;
import org.eclipse.ui.IEditorPart;

public class ConfigurationLaunchShortcut implements ILaunchShortcut {

	@Override
	public void launch(ISelection selection, String mode) {
		if (selection instanceof IStructuredSelection){
			IStructuredSelection structuredSelection=(IStructuredSelection) selection;
			if (!structuredSelection.isEmpty()){
				launch(structuredSelection.getFirstElement(), mode);
			}
		}
	}

	@Override
	public void launch(IEditorPart editor, String mode) {
		IEditorInput input=editor.getEditorInput();
		IFile file=input.getAdapter(IFile.class);
		if (file!=null){
			launch(file, mode);
		}

	}

	private void launch(Object firstElement, String mode) {
		IFile file=firstElement instanceof IFile? (IFile) firstElement : ((IAdaptable) firstElement).getAdapter(IFile.class);

		

	}



}
