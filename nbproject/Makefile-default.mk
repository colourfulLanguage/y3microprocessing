#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/MicroprocessorsLab.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/MicroprocessorsLab.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=
else
COMPARISON_BUILD=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=main.s config.s touchscreen.s experiment.s display.s timer.s UART.s

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/main.o ${OBJECTDIR}/config.o ${OBJECTDIR}/touchscreen.o ${OBJECTDIR}/experiment.o ${OBJECTDIR}/display.o ${OBJECTDIR}/timer.o ${OBJECTDIR}/UART.o
POSSIBLE_DEPFILES=${OBJECTDIR}/main.o.d ${OBJECTDIR}/config.o.d ${OBJECTDIR}/touchscreen.o.d ${OBJECTDIR}/experiment.o.d ${OBJECTDIR}/display.o.d ${OBJECTDIR}/timer.o.d ${OBJECTDIR}/UART.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/main.o ${OBJECTDIR}/config.o ${OBJECTDIR}/touchscreen.o ${OBJECTDIR}/experiment.o ${OBJECTDIR}/display.o ${OBJECTDIR}/timer.o ${OBJECTDIR}/UART.o

# Source Files
SOURCEFILES=main.s config.s touchscreen.s experiment.s display.s timer.s UART.s



CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk ${DISTDIR}/MicroprocessorsLab.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=PIC18F87K22
FINAL_IMAGE_NAME_MINUS_EXTENSION=${DISTDIR}/MicroprocessorsLab.${IMAGE_TYPE}
# ------------------------------------------------------------------------------------
# Rules for buildStep: pic-as-assembler
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/main.o: main.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/main.o \
	main.s \
	 -D__DEBUG=1   -mdfp="${DFP_DIR}/xc8"  -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/config.o: config.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/config.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/config.o \
	config.s \
	 -D__DEBUG=1   -mdfp="${DFP_DIR}/xc8"  -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/touchscreen.o: touchscreen.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/touchscreen.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/touchscreen.o \
	touchscreen.s \
	 -D__DEBUG=1   -mdfp="${DFP_DIR}/xc8"  -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/experiment.o: experiment.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/experiment.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/experiment.o \
	experiment.s \
	 -D__DEBUG=1   -mdfp="${DFP_DIR}/xc8"  -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/display.o: display.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/display.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/display.o \
	display.s \
	 -D__DEBUG=1   -mdfp="${DFP_DIR}/xc8"  -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/timer.o: timer.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/timer.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/timer.o \
	timer.s \
	 -D__DEBUG=1   -mdfp="${DFP_DIR}/xc8"  -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/UART.o: UART.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/UART.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/UART.o \
	UART.s \
	 -D__DEBUG=1   -mdfp="${DFP_DIR}/xc8"  -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
else
${OBJECTDIR}/main.o: main.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/main.o \
	main.s \
	  -mdfp="${DFP_DIR}/xc8"  -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/config.o: config.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/config.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/config.o \
	config.s \
	  -mdfp="${DFP_DIR}/xc8"  -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/touchscreen.o: touchscreen.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/touchscreen.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/touchscreen.o \
	touchscreen.s \
	  -mdfp="${DFP_DIR}/xc8"  -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/experiment.o: experiment.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/experiment.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/experiment.o \
	experiment.s \
	  -mdfp="${DFP_DIR}/xc8"  -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/display.o: display.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/display.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/display.o \
	display.s \
	  -mdfp="${DFP_DIR}/xc8"  -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/timer.o: timer.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/timer.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/timer.o \
	timer.s \
	  -mdfp="${DFP_DIR}/xc8"  -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/UART.o: UART.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/UART.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/UART.o \
	UART.s \
	  -mdfp="${DFP_DIR}/xc8"  -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: pic-as-linker
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${DISTDIR}/MicroprocessorsLab.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} ${DISTDIR} 
	${MP_LD} -mcpu=PIC18F87K22 ${OBJECTFILES_QUOTED_IF_SPACED} \
	-o ${DISTDIR}/MicroprocessorsLab.${IMAGE_TYPE}.${OUTPUT_SUFFIX} \
	 -D__DEBUG=1   -mdfp="${DFP_DIR}/xc8"  -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -mcallgraph=std -Wl,-Map=${FINAL_IMAGE_NAME_MINUS_EXTENSION}.map -mno-download-hex
else
${DISTDIR}/MicroprocessorsLab.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_LD} -mcpu=PIC18F87K22 ${OBJECTFILES_QUOTED_IF_SPACED} \
	-o ${DISTDIR}/MicroprocessorsLab.${IMAGE_TYPE}.${OUTPUT_SUFFIX} \
	  -mdfp="${DFP_DIR}/xc8"  -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -mcallgraph=std -Wl,-Map=${FINAL_IMAGE_NAME_MINUS_EXTENSION}.map -mno-download-hex
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r ${OBJECTDIR}
	${RM} -r ${DISTDIR}

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(wildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
