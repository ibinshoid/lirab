/**
 *	The strings like @VARIABLE@ in this file are replaced by cmake during the
 *	build process with the end result that build time parameters will be
 *	available to the built executable.
 */

namespace config {
	public const string PROJECT_NAME = "@PROJECT_NAME@";
  	public const string INSTALL_PATH = "@CMAKE_INSTALL_PREFIX@";
}
