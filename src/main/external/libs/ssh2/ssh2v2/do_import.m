%% LOAD JAVA LIB
%
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.File;


import ch.ethz.ssh2.*;
import ch.ethz.ssh2.Connection;
import ch.ethz.ssh2.Session;
import ch.ethz.ssh2.StreamGobbler;
import ch.ethz.ssh2.SCPClient;
import ch.ethz.ssh2.SFTPv3Client;
import ch.ethz.ssh2.SFTPv3FileHandle;