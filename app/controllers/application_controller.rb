# This is a hack to work around the fact that casino is hard-coded to inherit
# from ::ApplicationController. For clarity we're keeping it as
# CAS::ApplicationController and "aliasing" it.
ApplicationController = CAS::ApplicationController
