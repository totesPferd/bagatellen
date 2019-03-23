CC := clang
CXX := clang++
RTTIFLAG := -fno-rtti
CXXFLAGS := $(shell llvm-config --cxxflags) $(RTTIFLAG)
LLVMLDFLAGS := -v $(shell llvm-config --ldflags)

SOURCES =  LoopConvert.cpp
OBJECTS =  $(SOURCES:.cpp=.o)
EXES =  $(OBJECTS:.o=)
CLANGLIBS = \
    $(shell llvm-config --libs bitreader mcparser option support --system-libs) \
   -lclangAnalysis \
   -lclangAST \
   -lclangASTMatchers \
   -lclangBasic \
   -lclangDriver \
   -lclangEdit \
   -lclangFrontend \
   -lclangLex \
   -lclangParse \
   -lclangSema \
   -lclangSerialization \
   -lclangTooling

all: $(OBJECTS) $(EXES)
.PHONY: clean

%.o: %.cpp
	$(CXX) -c $< $(CXXFLAGS)

LoopConvert: LoopConvert.o
	$(CXX) -o $@ $< $(LLVMLDFLAGS) -Wl,--start-group $(CLANGLIBS) -Wl,--end-group

clean:
	rm -f $(EXES) $(OBJECTS) a.out

