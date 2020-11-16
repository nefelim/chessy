#include "pch.h"
#include <cstdlib>
#include <iostream>

#include "ContextProvider.h"

ContextProvider::ContextProvider(QObject * parent/* = nullptr*/)
    : QObject(parent)
{
}

Chessy::GnuChessEngine* ContextProvider::engine()
{
    return &m_engine;
}

