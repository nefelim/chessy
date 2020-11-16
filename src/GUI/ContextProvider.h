#pragma once
#include "GnuChessEngine.h"

/**
 * @brief The ContextProvider class
 * @class ContextProvider ContextProvider.h
 * @ingroup chessy
 */

class ContextProvider: public QObject
{
    Q_OBJECT

    Q_PROPERTY(Chessy::GnuChessEngine* engine READ engine CONSTANT)

public:
    /**
     * @brief Constructor.
     * @param parent parent object in the Qt hierarchy.
     */
    explicit ContextProvider(QObject* parent = nullptr);
    /**
     * @brief Get pointer to engine object.
     * @return
     */
    Chessy::GnuChessEngine* engine();

private:
    Chessy::GnuChessEngine m_engine;
};
