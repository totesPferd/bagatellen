CC := clang
CXX := clang++
RTTIFLAG := -fno-rtti
CXXFLAGS := $(shell llvm-config --cxxflags) $(RTTIFLAG)
LLVMLDFLAGS := -v $(shell llvm-config --ldflags)

SOURCES =  probe.cpp
OBJECTS =  $(SOURCES:.cpp=.o)
EXES =  $(OBJECTS:.o=)
CLANGLIBS = \
    $(shell llvm-config --libs --system-libs) \
   -lclang \
   -lclangARCMigrate \
   -lclangAST \
   -lclangASTMatchers \
   -lclangAnalysis \
   -lclangBasic \
   -lclangCodeGen \
   -lclangDriver \
   -lclangDynamicASTMatchers \
   -lclangEdit \
   -lclangFormat \
   -lclangFrontend \
   -lclangFrontendTool \
   -lclangIndex \
   -lclangLex \
   -lclangParse \
   -lclangRewrite \
   -lclangRewriteFrontend \
   -lclangSema \
   -lclangSerialization \
   -lclangStaticAnalyzerCheckers \
   -lclangStaticAnalyzerCore \
   -lclangStaticAnalyzerFrontend \
   -lclangTooling \
   -lclangToolingCore

all: $(OBJECTS) $(EXES)
.PHONY: clean

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $<

probe: probe.o
	$(CXX) -o $@ $< $(LLVMLDFLAGS) -Wl,--start-group $(CLANGLIBS) -Wl,--end-group

clean:
	rm -f $(EXES) $(OBJECTS) a.out

